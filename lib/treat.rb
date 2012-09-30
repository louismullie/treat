module Treat
  
  # Load all necessary files.
  require_relative 'treat/version'
  require_relative 'treat/exception'
  require_relative 'treat/modules'
  
  # Enable entity creation DSL.
  Treat::Config.sweeten!
  
  # Install packages for a given language.
  def self.install(language = :english)
    require_relative 'treat/installer'
    Treat::Installer.install(language)
  end

end