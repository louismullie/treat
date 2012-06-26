# Proxies install builders on core Ruby objects,
# so that methods called on them may be passed
# to the entity that can be built from the core
# class instance.
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
      Treat::Entities::Entity.from_string(self.to_s)
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
  
  # Include the proxies in the core classes.
  ::String.class_eval { include Treat::Core::Proxies::String }
  ::Numeric.class_eval { include Treat::Core::Proxies::Numeric }

  Treat::Entities::Entity.class_eval do
    
    alias :language_proxied :language
    
    def language(extractor = nil, options = {})
  
      return Treat.core.language.default if
      !Treat.core.language.detect

      if is_a?(Treat::Entities::Symbol) ||
        is_a?(Treat::Entities::Number)
        return Treat.core.language.default
      end

      dlvl = Treat.core.language.detect_at
      if (Treat.core.entities.rankings[type] <
        Treat.core.entities.rankings[dlvl]) &&
        has_parent?
        anc = ancestor_with_type(dlvl)
        return anc.language if anc
      end

      extractor ||= Treat.workers.
      extractors.language.default

      language_proxied(extractor, options)

    end

  end

end
