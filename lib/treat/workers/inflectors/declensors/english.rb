# Inflection using the inflect module copied from 
# the unmaintained 'english' ruby gem.
#
# License: MIT
# Website: http://english.rubyforge.org
class Treat::Workers::Inflectors::Declensors::English

  require_relative 'english/inflect'
  
  # Part of speech that can be declensed.
  POS = ['noun', 'adjective', 'determiner']
  
  # Retrieve the declensions (singular, plural)
  # of an english word using a class lifted from
  # the 'english' ruby gem.
  def self.declense(entity, options)
    cat = entity.check_has(:category)
    return unless POS.include?(cat)
    unless options[:count]
      raise Treat::Exception, 'Must supply ' +
      'option count ("singular" or "plural").'
    end
    string = entity.to_s
    if options[:count] == 'plural'
      Inflect.plural(string)
    elsif options[:count] == 'singular'
      Inflect.singular(string)
    end
  end
  
end