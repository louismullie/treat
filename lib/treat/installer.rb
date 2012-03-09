# Installer is a dependency manager for languages.
#
# It can be called by using Treat.install(:language).
module Treat::Installer

  # Require the Rubygem dependency installer.
  require 'rubygems/dependency_installer'
  require 'treat/downloader'
  
  # Binaries to install and their purpose.
  Binaries = {
    'ocropus' => 'recognize text in image files',
    'antiword' => 'extract text from DOC files',
    'poppler' => 'extract text from PDF files',
    'graphviz' => 'export and visualize directed graphs'
  }

  # Package managers for each platforms.
  PackageManagers = {
    :mac => 'port',
    :linux => 'apt-get',
    :windows => 'win-get'
  }

  # Address of the server with the files.
  Server = 'www.louismullie.com'

  # Filenames for the Stanford packages.
  StanfordPackages = {
    :english => "stanford-core-nlp-english.zip",
    :all => "stanford-core-nlp-all.zip"
  }

  # Install required dependencies and optional
  # dependencies for a specific language.
  def self.install(language = :english)

    lang_class = Treat::Languages.get(language)
    l = "#{language.to_s.capitalize} language"

    puts
    puts "Treat Installer, v. #{Treat::VERSION.to_s}\n"
    puts
    puts "Warning: depending on your configuration, "+
    "you may need to run Ruby on sudo."

    @@installer = Gem::DependencyInstaller.new

    begin

      title "Install required gem dependencies for the #{l}."
      install_required_dependencies(lang_class)

      title "Install optional gem dependencies for the #{l}."
      install_optional_dependencies(lang_class)

      title "Download model for the Punkt segmenter for the #{l}."
      download_punkt_models(language)
      
      title "Download Stanford Core NLP JARs and " +
      "model files for the the #{l}.\n\n"
      download_stanford(language)

      title "Install optional binaries "+
      "(you may need to authenticate this)."
      install_binaries
      
      #title "Downloading Wordnet database."
      #download_wordnet if language == :english

      puts
      puts "-----\nDone!"

    rescue Errno::EACCES => e

      raise Treat::Exception,
      "Couldn't write to file - permission denied (#{e.message}). " +
      "You may need to run Ruby or Rake on sudo."

    end

  end

  def self.install_required_dependencies(lang_class)

    required = lang_class::RequiredDependencies
    puts "No dependencies to install.\n" if required.empty?

    required.each do |dependency|
      puts "Installing required dependency"+
      " '#{dependency}'..."
      begin
        silence_warnings { @@installer.install(dependency) }
      rescue
        puts "Couldn't install '#{dependency}'. " +
        "You should install this dependency "+
        "manually by running: " +
        "`gem install #{dependency}`."
      end
    end

  end

  def self.install_optional_dependencies(lang_class)

    optional = lang_class::OptionalDependencies
    puts "No dependencies to install.\n" if optional.empty?

    optional.each do |dependency|
      install_optionally(dependency) do
        @@installer.install(dependency)
      end
    end

  end

  def self.install_binaries

    p = detect_platform
    man = PackageManagers[p]

    if !man
      puts "Cannot find a download manager "+
      "for the #{p} platform.\n\n"
    else
      unless `hash #{man} 2>&1` == ''
        puts "The '#{man}' command is required "+
        "to install binaries on #{p}.\n\n"
        man = nil
      end
    end

    unless man
      puts "Skipping installation of the "+
      "following binaries:\n\n"
      Binaries.each do |binary, purpose|
        puts "- #{binary} to #{purpose}"
      end
      return
    end

    Binaries.each do |binary, purpose|
      install_optionally(binary, purpose) do
        `sudo #{man} install #{binary}`
      end
    end

  end

  def self.download_stanford(language)

    language = :all unless language == :english
    f = StanfordPackages[language]

    download(f)

    puts "- Unzipping package ..."
    unzip_file(Treat.tmp + f, Treat.tmp)

    puts "- Cleaning up..."
    File.delete(Treat.tmp + f)
    FileUtils.rm_rf((Treat.tmp + f)[0...-4])

  end

  def self.download_punkt_models(language)

    f = "#{language}.yaml"
    download(f, 'punkt/')
    
    dest = "#{Treat.models}punkt/"
    puts "- Creating directory models/punkt ..."
    unless File.readable?(dest)
      FileUtils.mkdir_p(File.absolute_path(dest))
    end
    
    puts "- Copying model files to models/punkt ..."
    FileUtils.cp("#{Treat.tmp}punkt/#{f}", "#{Treat.models}punkt/#{f}")
    puts "- Cleaning up..."
    FileUtils.rm_rf("#{Treat.tmp}punkt")

  end

  def self.download_wordnet

  end


  private

  @@n = 1

  # Print out a numbered title.
  def self.title(string)
    puts
    puts "#{@@n}. #{string}"
    puts
    @@n += 1
  end

  # Install a dependency with a supplied purpose
  # but ask the user if she wishes to do so first.
  def self.install_optionally(dependency, purpose = '')

    begin
      purpose = "to #{purpose} " unless purpose == ''
      puts "Optionally install " +
      "'#{dependency}' #{purpose}? (yes/no, <enter> = skip) ?"
      answer = gets.strip
      unless ['yes', 'no', ''].include?(answer)
        raise Treat::Exception
      end
      if answer == 'yes'
        yield
      else
        puts "Skipped installing '#{dependency}'."
      end
    rescue Treat::Exception
      puts "Invalid input - valid options are 'yes' or 'no'."
      retry
    rescue
      puts "Couldn't install '#{dependency}'. " +
      "You can install this dependency manually "+
      "by running: 'gem install #{dependency}'."
    end

  end

  # Download a file without storing it
  # entirely in memory.
  def self.download(filename, dir = '')

    require 'net/http'
    require 'fileutils'
    require 'progressbar'

    if dir && !File.readable?(File.absolute_path(Treat.tmp + dir))
      FileUtils.mkdir_p(File.absolute_path(Treat.tmp + dir))
    end

    file = File.open(File.absolute_path(Treat.tmp + dir + filename), 'w')

    begin

      Net::HTTP.start(Server) do |http|

        http.request_get("/#{dir}#{filename}") do |response|
          pbar = ProgressBar.new(filename,
          response.content_length)

          response.read_body do |segment|
            pbar.inc(segment.length)
            file.write(segment)
          end

          pbar.finish
        end

      end

    rescue Errno::EEXIST
      raise Treat::Exception,
      "Skipping downloading file  "+
      "#{filename} because it already exists."
    rescue
      raise Treat::Exception,
      "Couldn't download file #{filename}."
      file.delete
    ensure
      file.close
    end

  end

  # Unzip a file to the destination path.
  def self.unzip_file(file, destination)

    require 'zip'

    Zip::ZipFile.open(file) do |zip_file|

      zip_file.each do |f|

        f_path = File.join(destination, f.name)

        FileUtils.mkdir_p(File.dirname(f_path))
        
        zip_file.extract(f, f_path) unless File.exist?(f_path)
        
        if File.readable?(Treat.tmp + '__MACOSX/')
          FileUtils.rm_rf(Treat.tmp + '__MACOSX/')
        end

        puts "- Creating directory bin/stanford ..."
        unless File.readable?(Treat.bin + 'stanford')
          FileUtils.mkdir_p(File.absolute_path(Treat.bin + 'stanford'))
        end

        puts "- Copying JAR files to bin/stanford ..."
        Dir.glob(File.join(f_path, '*.jar')) do |f|
          FileUtils.cp(Treat.tmp + f, Treat.bin + 'stanford/')
        end

        puts "- Creating directory models/stanford ..."
        unless File.readable?(Treat.models + 'stanford')
          FileUtils.mkdir_p(File.absolute_path(Treat.models + 'stanford/'))
        end

        puts "- Copying model files to models/stanford ..."
        
        Dir.entries(File.absolute_path(f_path)).each do |f|
          next if f == '.' || f == '..'
          if FileTest.directory?(f)
            FileUtils.cp_r(f, Treat.models + 'stanford/')
          end
        end

        break

      end

    end

  end

end
