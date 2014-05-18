# Date extraction using Ruby's standard library
# DateTime.parse() method.
class Treat::Workers::Extractors::Time::Ruby

  # Require Ruby's date module.
  require 'date'

  # Return a DateTime object representing the date/time
  # contained within the entity, using Ruby's native
  # date/time parser. This extractor is suitable for the
  # detection of well-structured dates and times, such as
  # 2011/02/03 5:00.
  #
  # Options: none.
  def self.time(entity, options = {})
    s = entity.to_s
    return if s =~ /^[0-9]+$/
    begin
      time = ::DateTime.parse(s)
      if  entity.has_parent? && 
        remove_time_from_ancestors(entity, time)
        nil
      else
        time
      end
    rescue
      nil
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