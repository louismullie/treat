module Treat
  class Installer
    require 'rubygems/dependency_installer'
    # Install required dependencies and optional dependencies
    # for a specific language.
    def self.install(language = :english)
      
      required = Treat::Languages::Dependencies::Required[language]
      optional = Treat::Languages::Dependencies::Optional[language]
      
      puts "Treat Installer\n\n"
      puts "Installing dependencies for the #{language.to_s.capitalize} language.\n\n"

      inst = Gem::DependencyInstaller.new
      
      required.each do |dependency|
        puts "Installing required dependency '#{dependency}'..."
        begin
          silence_warnings { inst.install(dependency) }
        rescue
          puts "Couldn't install '#{dependency}'. " +
          "You need install this dependency manually by running: " +
          "gem install #{dependency}."
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
          puts "Couldn't install '#{dependency}'. " +
          "You can install this dependency manually by running: " +
          "gem install #{dependency}."
        end
        
        puts "\nInstall completed."
        puts
      end
      
    end
  end
end
