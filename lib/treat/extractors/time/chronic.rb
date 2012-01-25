module Treat
  module Extractors
    module Time
      class Chronic
        silence_warnings { require 'chronic' }
        def self.time(entity, options = {})
          silence_warnings { ::Chronic.parse(entity.to_s, {:guess => true}) }
        end
      end
    end
  end
end