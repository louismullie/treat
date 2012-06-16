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
  
  # Fix -- This must be moved urgently.
  Treat::Entities::Entity.class_eval do

    alias :true_language :language
    
    def language(extractor = nil, options = {})
      
      if is_a?(Treat::Entities::Symbol) ||
        is_a?(Treat::Entities::Number)
        return Treat.core.language[:default]
      end
      
      if !Treat.core.language[:detect?]
        return Treat.core.language[:default]
      else
        dlvl = Treat.core.language[:detect_at]
        if (Treat::Entities.rank(type) <
          Treat::Entities.rank(dlvl)) &&
          has_parent?
          anc = ancestor_with_type(dlvl)
          return anc.language if anc
        end
      end
      
      true_language(extractor, options)
      
    end

  end
  
end