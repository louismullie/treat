module Treat
  # Proxies install Treat functions on core Ruby classes.
  module Proxies
    # The module proxy provides functionanaty common
    # to the different types of proxies.
    module Proxy
      # Build the entity corresponding to the proxied
      # object and send the method call to the entity.
      def method_missing(sym, *args, &block)
        if Treat::Categories.have_method?(sym)
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
      # Save the string to the specified file.
      def save(file)
        File.open(file, 'w') { |f| f.write(self) }
      end
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
        Treat::Entities::Entity.from_numeric(self)
      end
    end
    # Install Treat functions on Array objects.
    module Array
      include Treat::Proxies::Proxy
      # The behaviour of this proxy is special:
      # if a Treat function is called on an array,
      # the function will be called on each element
      # of the array and a new array with the 
      # results will be returned.
      def method_missing(sym, *args, &block)
        if Category.has_method?(sym)
          array = []
          each do |element|
            if element.is_a? Treat::Entities::Entity
              array << element.send(sym, *args)
            else
              unless [Numeric, String, Array].include?(element.class)
                raise Treat::Exception "Cannot convert object with type " +
                "#{element.class} into an entity."
              end
              array << element.to_entity.send(sym, *args)
            end
          end
          array
        else
          super(sym, *args, &block)
        end
      end
    end
    # Include the proxies in the core classes.
    ::String.class_eval { include Treat::Proxies::String }
    ::Numeric.class_eval { include Treat::Proxies::Numeric }
    ::Array.class_eval { include Treat::Proxies::Array }
  end
end
