# Proxies install builders on core Ruby objects;
# when a method defined by Treat is called on these
# objects, the Ruby object is cast to a Treat entity
# and the method is called on the resultant type.
module Treat::Proxies
  
  # Provides a base functionality for proxies.
  module Proxy
    # Build the entity corresponding to the proxied
    # object and send the method call to the entity.
    def method_missing(sym, *args, &block)
      if [:do, :apply].include?(sym) || 
        Treat::Workers.lookup(sym)
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

end
