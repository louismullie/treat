# Inflection using the inflect module copied from 
# the unmaintained 'english' ruby gem.
#
# License: MIT
# Website: http://english.rubyforge.org
class Treat::Workers::Inflectors::Declensors::English

  require 'treat/workers/inflectors/declensors/english/inflect'
  
  # Retrieve the declensions (singular, plural)
  # of an english word using a class lifted from
  # the 'english' ruby gem.
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
      Inflect.plural(string)
    elsif options[:count] == :singular
      Inflect.singular(string)
    end
    
  end
  
end