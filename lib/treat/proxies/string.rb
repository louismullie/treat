module Treat::Proxies

  # Install Treat functions on String objects.
  module String
    # Include base proxy functionality.
    include Treat::Proxies::Proxy
    # Return the entity corresponding to the string.
    def to_entity
      Treat::Entities::Entity.from_string(self)
    end
  end
  
  # Include Treat methods on strings.
  ::String.class_eval do
    include Treat::Proxies::String
  end
  
end
