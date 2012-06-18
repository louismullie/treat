# A wrapper for the 'chronic' gem, which parses
# date information.
#
# Project website: http://chronic.rubyforge.org/
class Treat::Workers::Extractors::Time::Chronic

  # Require the 'chronic' gem.
  silence_warnings { require 'chronic' }

  # Require the Ruby DateTime module
  require 'date'

  # Return the date information contained within 
  # the entity by parsing it with the 'chronic' gem.
  #
  # Options: none.
  def self.time(entity, options = {})

    s = entity.to_s
    return if s =~ /^[0-9]+$/
    time = nil
    
    silence_warnings do
      time = ::Chronic.parse(s, {:guess => true})
    end
    
    if entity.has_parent? && remove_time_from_ancestors(entity, time)
      nil
    else
      time
    end
    
  end
  
  # Keeps the lowest-level time annotations that do
  # not conflict with a higher time annotation.
  # Returns true if the entity conflicts with a
  # higher-level time annotation.
  def self.remove_time_from_ancestors(entity, time)
    
    entity.ancestors_with_type(:phrase).each do |a|
      
      next if !a.has?(:time)
      unless a.get(:time) == time
        return true
      end
      a.unset(:time)
      
    end
    
    false
    
  end

end
