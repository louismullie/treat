# A dependency manager for Treat language plugins.
# Usage: Treat::Installer.install('language')
module Treat::Core::Installer

  require 'schiphol'

  # Address of the server with the files.
  Server = 's3.amazonaws.com/static-public-assets'

  # Filenames for the Stanford packages.
  StanfordPackages = {
    :minimal => "stanford-core-nlp-minimal.zip",
    :english => "stanford-core-nlp-english.zip",
    :all => "stanford-core-nlp-all.zip"
  }

  # Absolute paths required for cp and mkdir.
  Paths = {
    :tmp => File.absolute_path(Treat.paths.tmp),
    :bin => File.absolute_path(Treat.paths.bin),
    :models => File.absolute_path(Treat.paths.models)
  }

  # Install required dependencies and optional
  # dependencies for a specific language.
  def self.install(language = 'english')

    # Require the Rubygem dependency installer.
    silence_warnings do
      require 'rubygems/dependency_installer'
    end

    @@installer = Gem::DependencyInstaller.new

    if language == 'travis'
      install_travis; return
    end

    l = "#{language.to_s.capitalize} language"

    puts "\nTreat Installer, v. #{Treat::VERSION.to_s}\n\n"

    begin

      title "Installing core dependencies."
      install_language_dependencies('agnostic')

      title "Installing dependencies for the #{l}.\n"
      install_language_dependencies(language)

      # If gem is installed only, download models.
      begin
        Gem::Specification.find_by_name('punkt-segmenter')
        title "Downloading models for the Punkt segmenter for the #{l}."
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

    rescue Errno::EACCES => e

      raise Treat::Exception,
      "Couldn't write to file - permission denied (#{e.message}). " +
      "You may need to run Ruby or Rake on sudo."

    end

  end

  # Minimal install for Travis CI.
  def self.install_travis
    install_language_dependencies(:agnostic)
    install_language_dependencies(:english)
    download_stanford(:minimal)
    download_punkt_models(:english)
  end


  def self.install_language_dependencies(language)
    dependencies = Treat.languages[language].dependencies
    puts "No dependencies to install.\n" if dependencies.empty?
    dependencies.each do |dependency|
      install_gem(dependency)
    end
  end

  def self.download_stanford(package = :minimal)

    f = StanfordPackages[package]
    url = "http://#{Server}/treat/#{f}"
    loc = Schiphol.download(url,
      download_folder: Treat.paths.tmp
    )
    puts "- Unzipping package ..."
    dest = File.join(Treat.paths.tmp, 'stanford')
    unzip_stanford(loc, dest)

    model_dir = File.join(Paths[:models], 'stanford')
    bin_dir = File.join(Paths[:bin], 'stanford')
    origin = File.join(Paths[:tmp], 'stanford')

    # Mac hidden files fix.
    mac_remove = File.join(dest, '__MACOSX')
    if File.readable?(mac_remove)
      FileUtils.rm_rf(mac_remove)
    end

    unless File.readable?(bin_dir)
      puts "- Creating directory bin/stanford ..."
      FileUtils.mkdir_p(bin_dir)
    end

    unless File.readable?(model_dir)
      puts "- Creating directory models/stanford ..."
      FileUtils.mkdir_p(model_dir)
    end

    puts "- Copying JAR files to bin/stanford " +
         "and model files to models/stanford ..."
    Dir.glob(File.join(origin, '*')) do |f|
      next if ['.', '..'].include?(f)
      if f.index('jar')
        FileUtils.cp(f, File.join(Paths[:bin],
        'stanford', File.basename(f)))
      elsif FileTest.directory?(f)
        FileUtils.cp_r(f, model_dir)
      end
    end

    puts "- Cleaning up..."
    FileUtils.rm_rf(origin)

    'Done.'

  end

  def self.download_punkt_models(language)

    f = "#{language}.yaml"
    dest = "#{Treat.paths.models}punkt/"
    url = "http://#{Server}/treat/punkt/#{f}"
    loc = Schiphol.download(url,
      download_folder: Treat.paths.tmp
    )
    unless File.readable?(dest)
      puts "- Creating directory models/punkt ..."
      FileUtils.mkdir_p(File.absolute_path(dest))
    end

    puts "- Copying model file to models/punkt ..."
    FileUtils.cp(loc, File.join(Paths[:models], 'punkt', f))

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
  def self.install_gem(dependency)

    begin
      puts "Installing #{dependency}...\n"
      @@installer.install(dependency)
    rescue Gem::InstallError => error
      puts "Warning: couldn't install " +
      "gem '#{dependency}' (#{error.message})."
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
