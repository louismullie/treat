module Treat
  
  # Treat requires Ruby >= 1.9.2
  if RUBY_VERSION < '1.9.2'
    raise "Treat requires Ruby version 1.9.2 " +
    "or higher, but current is #{RUBY_VERSION}."
  end
  
  # Custom exception class.
  class Exception < ::Exception; end
  
  # Require dependencies.
  require 'bundler'
  Bundler.require
  
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