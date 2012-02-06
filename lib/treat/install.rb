module Treat
  class Installer
    require 'rubygems/dependency_installer'
    # Install required dependencies and optional dependencies
    # for a specific language.
    def self.install(language = :english)

      lang = Treat::Languages.get(language)
      required = lang::RequiredDependencies
      optional = lang::OptionalDependencies

      puts "Treat Installer\n\n"
      puts "Installing dependencies for the #{language.to_s.capitalize} language.\n\n"
      
      flag = false
      
      inst = Gem::DependencyInstaller.new

      required.each do |dependency|
        puts "Installing required dependency '#{dependency}'..."
        begin
          silence_warnings { inst.install(dependency) }
        rescue
          flag = true
          puts "Couldn't install '#{dependency}'. " +
          "You need install this dependency manually by running: " +
          "'gem install #{dependency}' or use 'sudo' to run this script."
        end
      end

      optional.each do |dependency|
        begin
          puts "Install optional dependency '#{dependency}' (yes/no, <enter> = skip) ?"
          answer = gets.strip
          raise Treat::Exception unless ['yes', 'no', ''].include?(answer)
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
          flag = true
          puts "Couldn't install '#{dependency}'. " +
          "You can install this dependency manually by running: " +
          "'gem install #{dependency}' or use 'sudo' to run this script."
        end
      end

      w = flag ? 'incompletely' : 'normally'
      puts "\nInstall proceeded #{w}."
      puts

    end
  end
end
