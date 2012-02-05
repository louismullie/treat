module Treat
  module Extractors
    module Time
      # A wrapper for Ruby's native date/time parsing.
      class Ruby
        require 'date'
        # Return a DateTime object representing the date/time
        # contained within the entity, using Ruby's native
        # date/time parser.
        #
        # Options: none.
        def self.time(entity, options = {})
          begin
            { :start_time => ::DateTime.parse(entity.to_s) }
          rescue
            {}
          end
        end
      end
    end
  end
end
