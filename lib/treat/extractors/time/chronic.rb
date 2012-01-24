module Treat
  module Extractors
    module Time
      class Chronic
        silently { require 'chronic' }
        def self.time(entity, options = {})
          silently { ::Chronic.parse(entity.to_s, {:guess => true}) }
        end
      end
    end
  end
end