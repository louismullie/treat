module Treat::Proxies
  
  module Array
    # Include base proxy functionality.
    include Treat::Proxies::Proxy
    def method_missing(sym, *args, &block)
      if [:do, :apply].include?(sym) || 
        Treat::Workers.lookup(sym)
        map do |el|
          el.to_entity.send(sym, *args)
        end
      else
        super(sym, *args, &block)
      end
    end
  end
  
  # Include Treat methods on numerics.
  ::Array.class_eval do
    include Treat::Proxies::Array
  end

end
