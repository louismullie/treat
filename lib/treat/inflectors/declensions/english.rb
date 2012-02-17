# This class is a wrapper for the Inflect module,
# copied from the unmaintained 'english' ruby gem,
# created by Thomas Sawyer.
#
# Released under the MIT License.
#
#  http://english.rubyforge.org
class Treat::Inflectors::Declensions::English

  require 'treat/inflectors/declensions/english/inflect'
  
  # Retrieve the declensions (singular, plural)
  # of an english word using a class lifted from
  # the 'english' ruby gem.
  def self.declensions(entity, options)
    
    
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