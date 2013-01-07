# Time/date extraction using a simple rule-based library.
# 
# Supported formats: Today, yesterday, tomorrow, 
# last thursday, this thursday, 14 Sep, 14 June 2010. 
# Any dates without a year are assumed to be in the past.
class Treat::Workers::Extractors::Time::Kronic

  require 'kronic'
  require 'date'

  # Return the date information contained within 
  # the entity by parsing it with the 'chronic' gem.
  #
  # Options: none.
  def self.time(entity, options = {})
    time = Kronic.parse(entity.to_s)
    time.is_a?(DateTime) ? time : nil
  end

end
