# Installer is a dependency manager for languages.
#
# It can be called by using Treat.install(:language).
module Treat::Installer

  # Require the Rubygem dependency installer.
  require 'rubygems/dependency_installer'

  # Install required dependencies and optional
  # dependencies for a specific language.
  def self.install(language = :english)

    lang = Treat::Languages.get(language)
    required = lang::RequiredDependencies
    optional = lang::OptionalDependencies

    puts "Treat Installer\n\n"
    puts "Installing dependencies for the "+
    "#{language.to_s.capitalize} language.\n\n"

    incomplete = false
    inst = Gem::DependencyInstaller.new

    required.each do |dependency|
      puts "Installing required dependency"+
      " '#{dependency}'..."
      begin
        silence_warnings { inst.install(dependency) }
      rescue
        incomplete = true
        puts "Couldn't install '#{dependency}'. " +
        "You need install this dependency "+
        "manually by running: " +
        "'gem install #{dependency}'."
      end
    end

    optional.each do |dependency|
      begin
        puts "Install optional dependency " +
        "'#{dependency}' (yes/no, <enter> = skip) ?"
        answer = gets.strip
        unless ['yes', 'no', ''].include?(answer)
          raise Treat::Exception
        end
        if answer == 'yes'
          silence_warnings { inst.install(dependency) }
        else
          puts "Skipped installing '#{dependency}'."
          next
        end
      rescue Treat::Exception
        puts "Invalid input - valid options are 'yes' or 'no'."
        retry
      rescue
        incomplete = true
        puts "Couldn't install '#{dependency}'. " +
        "You can install this dependency manually "+
        "by running: 'gem install #{dependency}'."
      end
    end

    w = incomplete ? 'incompletely' : 'normally'
    puts "\nInstall proceeded #{w}."
    puts

  end

end
