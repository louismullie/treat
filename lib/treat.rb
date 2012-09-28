module Treat
  
  # Treat requires Ruby >= 1.9.2
  if RUBY_VERSION < '1.9.2'
    raise "Treat requires Ruby version 1.9.2 " +
    "or higher, but current is #{RUBY_VERSION}."
  end
  
  # Custom exception class.
  class Exception < ::Exception; end
  class UnsupportedException < Exception; end
  
  # Load configuration options.
  require_relative 'treat/config'
  # Load all workers.
  require_relative 'treat/helpers'
  # Require library loaders.
  require_relative 'treat/loaders'
  # Require all core classes.
  require_relative 'treat/core'
  # Require all entity classes.
  require_relative 'treat/entities'
  # Lazy load worker classes.
  require_relative 'treat/workers'
  # Require proxies last.
  require_relative 'treat/proxies'
  
  # Turn sugar on.
  Treat::Config.sweeten!
  
  # Install packages for a given language.
  def self.install(language = :english)
    require_relative 'treat/installer'
    Treat::Installer.install(language)
  end

end