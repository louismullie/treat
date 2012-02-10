module Treat
  
  # Treat requires Ruby 1.9 or higher.
  if RUBY_VERSION <= '1.9'
    raise 'Treat requires Ruby 1.9 or higher.'
  end
  
  #$LOAD_PATH << '/ruby/gems/treat/lib/' # Remove for release

  # The current version of Treat.
  VERSION = "0.2.5"

  # Add methods to handle syntactic sugar,
  # language configuration options, and paths.
  require 'treat/configurable'
  extend Treat::Configurable
  
  # Require all files for the Treat library.
  require 'treat/object'
  require 'treat/kernel'
  require 'treat/exception'
  require 'treat/languages'
  require 'treat/entities'
  require 'treat/categories'
  require 'treat/proxies'

  # Install packages for a given language.
  def self.install(language = :english)
    require 'treat/installer'
    Treat::Installer.install(language)
  end
  
end