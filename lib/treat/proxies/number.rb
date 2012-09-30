module Treat::Proxies

  # Install Treat functions on Numeric objects.
  module Numeric
    # Include base proxy functionality.
    include Treat::Proxies::Proxy
    # Return the entity corresponding to the number.
    def to_entity(builder = nil)
      Treat::Entities::Number.from_numeric(self)
    end
  end
  
  # Include Treat methods on numerics.
  ::Numeric.class_eval do
    include Treat::Proxies::Numeric
  end
  
end
