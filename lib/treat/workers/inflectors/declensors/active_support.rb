# This class is a wrapper for the ActiveSupport
# declension tools.
class Treat::Workers::Inflectors::Declensors::English

  require 'active_support/inflector/inflections'

  # Declense a word using ActiveSupport::Inflector::Inflections
  def self.declense(entity, options)
    
    cat = entity.check_has(:category)
    unless ['noun', 'adjective', 'determiner'].
      include?(cat)
        return
    end
    
    unless options[:count]
      raise Treat::Exception,
      "Must supply option count (:singular or :plural)."
    end
    
    string = entity.to_s

    if options[:count] == :plural
      ActiveSupport::Inflector::Inflections.pluralize(string)
    elsif options[:count] == :singular
      ActiveSupport::Inflector::Inflections.singularize(string)
    end
    
  end
  
end