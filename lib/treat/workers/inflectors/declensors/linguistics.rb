# Inflection using the the 'linguistics' gem (will attempt
# to load the Linguistics module corresponding to the
# language of the entity.
#
# Website: http://deveiate.org/projects/Linguistics/
class Treat::Workers::Inflectors::Declensors::Linguistics

  # Part of speech that can be declensed.
  POS = ['noun', 'adjective', 'determiner']
  
  # Retrieve a declension of a word using the 'linguistics' gem.
  #
  # Options:
  #
  # - (Identifier) :count => :singular, :plural
  def self.declense(entity, options = {})

    cat = entity.get(:category)
    return if cat && !POS.include?(cat)
    
    unless options[:count]
      raise Treat::Exception, 'Must supply ' +
      ':count option ("singular" or "plural").'
    end

    unless options[:count].to_s == 'plural'
      raise Treat::Exception,
      "Ruby Linguistics does not support " +
      "singularization of words."
    end

    lang = entity.language
    code = Treat::Loaders::Linguistics.load(lang)
    obj = entity.to_s.send(code)

    if cat = entity.get(:category)
      method = "plural_#{cat}"
      obj.send(method)
    else; obj.plural; end

  end

end
