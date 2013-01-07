# Time/date extraction using a rule-based, pure 
# Ruby natural language date parser.
class Treat::Workers::Extractors::Time::Chronic

  require 'chronic'
  require 'date'
  
  DefaultOptions = {guess: true}

  # Return the date information contained within 
  # the entity by parsing it with the 'chronic' gem.
  def self.time(entity, options = {})
    options = DefaultOptions.merge(options)
    time = ::Chronic.parse(entity.to_s, options)
    time ? DateTime.parse(time.to_s) : nil
  end

end
