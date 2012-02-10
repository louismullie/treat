# A wrapper for the 'chronic' gem, which parses
# date information.
#
# Project website: http://chronic.rubyforge.org/
class Treat::Extractors::Date::Chronic

  # Require the Chronic gem.
  silence_warnings { require 'chronic' }

  # Require the Ruby date module
  require 'date'

  # Return the date information contained within the entity
  # by parsing it with the 'chronic' gem.
  #
  # Options: none.
  def self.date(entity, options = {})
    date = nil
    return if entity.has?(:time)
    s = entity.to_s.gsub('\/', '/').strip
    silence_warnings do
      date = ::Chronic.parse(s, {:guess => true})
    end
    # Return the lowest level phrase possible.
    entity.ancestors_with_type(:phrase).each do |a|
      a.unset(:date) if a.has?(:date)
    end
    date.to_date if date
  end

end
