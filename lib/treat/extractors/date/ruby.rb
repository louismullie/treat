module Treat
  module Extractors
    module Date
      # A wrapper for Ruby's native date parsing.
      class Ruby
        require 'date'
        # Return a DateTime object representing the date/date
        # contained within the entity, using Ruby's native
        # date/date parser.
        #
        # Options: none.
        def self.date(entity, options = {})
          begin
            s = entity.to_s.strip
            s.gsub!('\/', '/')
            date = ::DateTime.parse(s)
            date.to_date
          rescue
            nil
          end
        end
      end
    end
  end
end