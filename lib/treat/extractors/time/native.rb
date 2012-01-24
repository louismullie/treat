module Treat
  module Extractors
    module Time
      module Native
        require 'date'
        def self.time(entity, options = {})
          ::DateTime.parse(entity.to_s)
        end
      end
    end
  end
end
