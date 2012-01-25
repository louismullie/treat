module Treat
  module Extractors
    module Time
      # A wrapper for the 'chronic' gem, which parses
      # time and date information.
      # 
      # Project website: http://chronic.rubyforge.org/
      class Chronic
        silence_warnings { require 'chronic' }
        # Return the time information contained within the entity
        # by parsing it with the 'chronic' gem.
        # 
        # Options: none.
        def self.time(entity, options = {})
          silence_warnings { ::Chronic.parse(entity.to_s, {:guess => true}) }
        end
      end
    end
  end
end