module Treat
  
  # Require the current version.
  require 'treat/version'
  
  # Custom exception class.
  class Exception < ::Exception; end
  class UnimplementedException < Exception; end
  
  # Base module with auto-require.
  module Module
    def self.included(base)
      bits = base.ancestors[0].to_s.split('::').
      collect! { |bit| bit.downcase }
      Dir.glob(Treat.paths.lib +
      bits.join('/') + '/*.rb').
      each { |f| require_relative f }
    end
  end

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
  
  # Enable entity creation DSL.
  Treat::Config.sweeten!
  
  # Install packages for a given language.
  def self.install(language = :english)
    require_relative 'treat/installer'
    Treat::Installer.install(language)
  end

end