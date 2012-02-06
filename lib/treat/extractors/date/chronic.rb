module Treat
  module Extractors
    module Date
      # A wrapper for the 'chronic' gem, which parses
      # date information.
      #
      # Project website: http://chronic.rubyforge.org/
      class Chronic
        silence_warnings { require 'chronic' }
        require 'date'
        # Return the date information contained within the entity
        # by parsing it with the 'chronic' gem.
        #
        # Options: none.
        def self.date(entity, options = {})
          date = nil
          return if entity.has?(:time)
          s = entity.to_s
          s.gsub!('\/', '/')
          s.strip!
          silence_warnings do
            date = ::Chronic.parse(s, {:guess => true})
          end
          entity.ancestors_with_type(:phrase).each do |a|
            a.unset(:date) if a.has?(:date)
          end
          return date.to_date if date
        end
      end
    end
  end
end
