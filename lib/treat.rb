module Treat
  
  # Treat requires Ruby >= 1.9.2
  if RUBY_VERSION < '1.9.2'
    raise "Treat requires Ruby version 1.9.2 " +
    "or higher, but current is #{RUBY_VERSION}."
  end
  
  # Require custom exception class.
  require 'treat/exception'
  # Load configuration options.
  require 'treat/config'
  # Load all workers.
  require 'treat/helpers'
  # Require all core classes.
  require 'treat/core'
  # Require all entity classes.
  require 'treat/entities'
  # Lazy load worker classes.
  require 'treat/workers'
  # Require proxies last.
  require 'treat/proxies'
  
  # Turn sugar on.
  Treat::Config.sweeten!
  
  # Install packages for a given language.
  def self.install(language = :english)
    require 'treat/installer'
    Treat::Installer.install(language)
  end

end