# Proxies install builders on core Ruby objects;
# when a method defined by Treat is called on these
# objects, the Ruby object is cast to a Treat entity
# and the method is called on the resultant type.
module Treat::Core::Proxies

  # Provides a base functionality for proxies.
  module Proxy

    # Build the entity corresponding to the proxied
    # object and send the method call to the entity.
    def method_missing(sym, *args, &block)
      if sym == :do || Treat::Workers.lookup(sym)
        to_entity.send(sym, *args)
      else
        super(sym, *args, &block)
      end
    end

    # Create an unknown type of entity by default.
    def to_entity(builder = nil)
      Treat::Entities::Unknown(self.to_s)
    end

  end

  # Install Treat functions on String objects.
  module String

    # Include base proxy functionality.
    include Treat::Core::Proxies::Proxy

    # Return the entity corresponding to the string.
    def to_entity
      Treat::Entities::Entity.from_string(self)
    end

  end

  # Install Treat functions on Numeric objects.
  module Numeric

    # Include base proxy functionality.
    include Treat::Core::Proxies::Proxy

    # Return the entity corresponding to the number.
    def to_entity(builder = nil)
      Treat::Entities::Number.from_numeric(self)
    end

  end
  
  # Include Treat methods on strings.
  ::String.class_eval do
    include Treat::Core::Proxies::String
  end
  
  # Include Treat methods on numerics.
  ::Numeric.class_eval do
    include Treat::Core::Proxies::Numeric
  end
  
  # This is kind of ugly; need to find a
  # better solution eventually (?)
  Treat::Entities::Entity.class_eval do
    
    # Rename the true language detection
    # method to :language_proxied, and
    # only call it if language detection
    # is turned on in the configuration.
    alias :language_proxied :language
    
    # Proxy the #language method, defined on
    # all textual entities, in order to catch
    # the method call if language detection is
    # turned off and return the default language
    # in that case.
    def language(extractor = nil, options = {})
  
      return Treat.core.language.default if
      !Treat.core.language.detect

      if is_a?(Treat::Entities::Symbol) ||
        is_a?(Treat::Entities::Number)
        return Treat.core.language.default
      end

      dlvl = Treat.core.language.detect_at
      dklass = Treat::Entities.const_get(cc(dlvl))
      
      if self.compare_with(dklass) < 1 && has_parent?
        anc = ancestor_with_type(dlvl)
        return anc.language if anc
      end

      extractor ||= Treat.workers.
      extractors.language.default

      language_proxied(extractor, options)

    end

  end

end
