# This class is a wrapper for the functions included
# in the 'linguistics' gem that allow to obtain the
# declensions of a word.
#
# Project website: http://deveiate.org/projects/Linguistics/
class Treat::Inflectors::Declensions::Linguistics

  require 'treat/helpers/linguistics_loader'

  # Retrieve a declension of a word using the 'linguistics' gem.
  #
  # Options:
  #
  # - (Identifier) :count => :singular, :plural
  def self.declensions(entity, options = {})
    
    unless options[:count]
      raise Treat::Exception,
      "Must supply option count (:singular or :plural)."
    end
    
    klass = Treat::Helpers::LinguisticsLoader.load(entity.language)
    string = entity.to_s
    
    if options[:count] == :plural
      
      if entity.has?(:category) &&
        [:noun, :adjective, :verb].
        include?(entity.category)
        silence_warnings do
          klass.send(
          :"plural_#{entity.category}", 
          string)
        end
      else
        klass.plural(string)
      end
      
    end
    
  end

end