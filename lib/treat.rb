module Treat
  
  # Treat requires Ruby >= 1.9.2
  if RUBY_VERSION < '1.9.2'
    raise "Treat requires Ruby version 1.9.2 " +
    "or higher, but current is #{RUBY_VERSION}."
  end

  # Current version
  VERSION = "1.0.6"
  
  # Custom exception class.
  class Exception < ::Exception; end
  
  # Require gem dependencies.
  require 'schiphol'
  
  # Load configuration options.
  require 'treat/config'
  # Load all workers.
  require 'treat/helpers'
  # Require all entity classes.
  require 'treat/entities'
  # Lazy load worker classes.
  require 'treat/workers'
  # Require all core classes.
  require 'treat/core'
  
  # Turn sugar on.
  Treat::Config.sweeten!
  
end