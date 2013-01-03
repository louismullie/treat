# This class is a wrapper for the functions included
# in the 'linguistics' gem that allow to describe a
# number in words in ordinal form.
#
# Project website: http://deveiate.org/projects/Linguistics/
class Treat::Workers::Inflectors::Ordinalizers::Linguistics

  DefaultOptions = {
    :language => Treat.core.language.default
  }
  
  # Desribe a number in words in ordinal form, using the
  # 'linguistics' gem.
  def self.ordinal(entity, options = {})
    options = DefaultOptions.merge(options)
    lang = entity.language
    code = Treat::Loaders::Linguistics.load(lang)
    entity.to_s.send(code).ordinate
  end
  
end