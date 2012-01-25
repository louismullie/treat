module Treat
  module Extractors
    module Time
      # A wrapper for Ruby's native date/time parsing.
      module Native
        require 'date'
        # Return a DateTime object representing the date/time
        # contained within the entity, using Ruby's native
        # date/time parser.
        def self.time(entity, options = {})
          ::DateTime.parse(entity.to_s)
        end
      end
    end
  end
end
