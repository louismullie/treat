module Treat
  # Proxies install Treat functions on core Ruby classes.
  module Proxies
    # The module proxy provides functionanaty common
    # to the different types of proxies.
    module Proxy
      # Build the entity corresponding to the proxied
      # object and send the method call to the entity.
      def method_missing(sym, *args, &block)
        if sym == :do || Treat::Categories.lookup(sym)
          to_entity.send(sym, *args)
        else
          super(sym, *args, &block)
        end
      end
      def to_entity(builder = nil)
        Treat::Entities::Unknown(self.to_s)
      end
    end
    # Install Treat functions on String objects.
    module String
      include Treat::Proxies::Proxy
      # Return the entity corresponding to the string.
      def to_entity
        Treat::Entities::Entity.from_string(self.to_s)  
      end
    end
    # Install Treat functions on Numeric objects.
    module Numeric
      include Treat::Proxies::Proxy
      # Return the entity corresponding to the number.
      def to_entity(builder = nil)
        Treat::Entities::Number.from_numeric(self)
      end
    end
    # Include the proxies in the core classes.
    ::String.class_eval { include Treat::Proxies::String }
    ::Numeric.class_eval { include Treat::Proxies::Numeric }
  end
end
