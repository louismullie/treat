# Installer is a dependency manager for languages.
#
# It can be called by using Treat.install(language).
module Treat::Installer

  # Require the Rubygem dependency installer.
  require 'rubygems/dependency_installer'
  require 'treat/downloader'
  require 'treat/dependencies'

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
    :minimal => "stanford-core-nlp-minimal.zip",
    :english => "stanford-core-nlp-english.zip",
    :all => "stanford-core-nlp-all.zip"
  }

  # Absolute paths required for cp and mkdir.
  Paths = {
    :tmp => File.absolute_path(Treat.tmp),
    :bin => File.absolute_path(Treat.bin),
    :models => File.absolute_path(Treat.models)
  }
  
  # Install required dependencies and optional
  # dependencies for a specific language.
  def self.install(language = :english)
    
    @@installer = Gem::DependencyInstaller.new
    
    if language == :travis
      install_travis; return
    end
    
    lang_class = Treat::Languages.get(language.to_s)
    l = "#{language.to_s.capitalize} language"

    puts
    puts "Treat Installer, v. #{Treat::VERSION.to_s}\n"
    puts
    
    begin

      title "Install language-independent gem dependencies."

      case prompt(
        "1 - Install all default language-independent dependencies\n" +
        "2 - Select dependencies to install manually\n" +
        "3 - Skip this step", ['1', '2', '3'])
      when '1' then install_dependencies(false)
      when '2' then install_dependencies(true)
      when '3' then puts 'Skipping this step.'
      end

      title "Install gem dependencies for the #{l}.\n"

      dflt = lang_class::RequiredDependencies
      all = lang_class::RequiredDependencies + lang_class::OptionalDependencies
      case prompt("1 - Install default dependencies.\n" +
        "2 - Select dependencies to install manually.\n" +
        "3 - Skip this step.", ['1', '2', '3'])
      when '1' then install_language_dependencies(dflt, false)
      when '2' then install_language_dependencies(all, true)
      when '3' then puts 'Skipping this step.'
      end
      
      Treat::Downloader.show_progress = true
      
      # If gem is installed only, download models.
      begin
        Gem::Specification.find_by_name('punkt-segmenter')
        title "Downloading model for the Punkt segmenter for the #{l}."
        download_punkt_models(language)
      rescue Gem::LoadError; end

      # If stanford is installed, download models.
      begin
        Gem::Specification.find_by_name('stanford-core-nlp')
        title "Download Stanford Core NLP JARs and " +
        "model files for the the #{l}.\n\n"
        package = (language == :english) ? :english : :all
        download_stanford(package)
      rescue Gem::LoadError; end

      title "Install external binary libraries (requires port, apt-get or win-get).\n"
      puts "Warning: this may take a long amount of time."

      case prompt("1 - Select binaries to install manually.\n" +
        "2 - Skip this step.", ['1', '2'])
      when '1' then install_binaries
      when '2' then puts 'Skipping this step.'
      end

      puts
      puts "-----\nDone!"

    rescue Errno::EACCES => e

      raise Treat::Exception,
      "Couldn't write to file - permission denied (#{e.message}). " +
      "You may need to run Ruby or Rake on sudo."

    end

  end
  
  # Automated install for Travis CI.
  def self.install_travis
    dep = (Treat::Languages::English::RequiredDependencies + 
          Treat::Languages::English::OptionalDependencies)
    install_dependencies(false)
    install_language_dependencies(dep, false)
    download_stanford(:minimal)
    download_punkt_models(:english)
  end
  
  def self.install_dependencies(optionally)

    Treat::Dependencies::Gem.each do |d|
      dep, ver, pur = *d
      install_gem(dep, ver, pur, optionally)
    end

  end

  def self.install_language_dependencies(dependencies, optionally)

    puts "No dependencies to install.\n" if dependencies.empty?
    dependencies.each do |dependency|
      install_gem(dependency, nil, nil, optionally)
    end

  end

  def self.install_binaries

    puts "Warning: this will require authentification."

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

    Treat::Dependencies::Binary.each do |binary, purpose|
      if prompt("install #{binary} to " +
        "#{purpose} (y/n)", ['y', 'n']) == 'y'
        `sudo #{man} install #{binary}`
      end
    end

  end

  def self.download_stanford(package = :minimal)
    
    f = StanfordPackages[package]
    loc = Treat::Downloader.download(
    'http', Server, 'treat', f, Treat.tmp)
    
    puts "- Unzipping package ..."
    unzip_stanford(loc, Treat.tmp)
    
    # Mac hidden files fix.
    if File.readable?(Treat.tmp + '__MACOSX/')
      FileUtils.rm_rf(Paths[:tmp] + '__MACOSX/')
    end
    
    unless File.readable?(Treat.bin + 'stanford')
      puts "- Creating directory bin/stanford ..."
      FileUtils.mkdir_p(
      Paths[:bin] + 
      'stanford/')
    end

    puts "- Copying JAR files to bin/stanford ..."
    
    Dir.glob(File.join(Paths[:tmp], '*.jar')) do |f|
      next if File.readable?(f)
      FileUtils.cp(
        File.join(File.absolute_path(f)), 
        File.join(Paths[:bin], 'stanford/')
      )
    end

    unless File.readable?(Treat.models + 'stanford')
      puts "- Creating directory models/stanford ..."
      FileUtils.mkdir_p(Paths[:models] + 'stanford/')
    end

    puts "- Copying model files to models/stanford ..."

    Dir.entries(Paths[:tmp]).each do |f|
      next if f == '.' || f == '..'
      next if File.readable?(f)
      if FileTest.directory?(f)
        FileUtils.cp_r(File.absolute_path(f), 
        Paths[:models] + 'stanford/')
      end
    end
    
    puts "- Cleaning up..."
    FileUtils.rm_rf(Paths[:tmp] + Server)
    
  end

  def self.download_punkt_models(language)

    f = "#{language}.yaml"
    dest = "#{Treat.models}punkt/"
    
    loc = Treat::Downloader.download(
    'http', Server, 'treat/punkt', f, Treat.tmp)

    unless File.readable?(dest)
      puts "- Creating directory models/punkt ..."
      FileUtils.mkdir_p(File.absolute_path(dest))
    end

    puts "- Copying model file to models/punkt ..."
    FileUtils.cp(File.absolute_path(loc), 
    Paths[:models] + "/punkt/#{f}")
    
    puts "- Cleaning up..."
    FileUtils.rm_rf(Paths[:tmp] + Server)

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
  def self.install_gem(dependency, version = nil, 
    purpose = nil, optionally = false)

    install = false

    begin
      purpose = purpose ? " to #{purpose}" : ''
      if optionally
        if prompt("install #{dependency}#{purpose}", 
          ['y', 'n']) == 'y'
          install = true
        end
      else
        puts "\n- Installing #{dependency}#{purpose}."
        install = true
      end
      silence_warnings do 
        @@installer.install(dependency, version)
      end if install
    rescue Exception => error
      puts "Couldn't install gem '#{dependency}' " +
           "(#{error.message})."
    end
    
  end

  # Unzip a file to the destination path.
  def self.unzip_stanford(file, destination)

    require 'zip/zip'
    f_path = ''
    
    Zip::ZipFile.open(file) do |zip_file|
      zip_file.each do |f|
        f_path = File.join(destination, f.name)
        FileUtils.mkdir_p(File.absolute_path(File.dirname(f_path)))
        zip_file.extract(f, f_path) unless File.exist?(f_path)
      end
    end

  end

end
