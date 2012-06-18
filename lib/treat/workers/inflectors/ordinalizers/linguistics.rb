# This class is a wrapper for the functions included
# in the 'linguistics' gem that allow to describe a
# number in words in ordinal form.
#
# Project website: http://deveiate.org/projects/Linguistics/
class Treat::Workers::Inflectors::Ordinalizers::Linguistics

  require 'treat/loaders/linguistics'
  
  DefaultOptions = {
    :language => Treat.core.language.default
  }
  
  # Desribe a number in words in ordinal form, using the
  # 'linguistics' gem.
  def self.ordinal(number, options = {})
    options = DefaultOptions.merge(options)
    klass = Treat::Loaders::
    Linguistics.load(options[:language])
    klass.ordinate(number.to_s)
  end
  
end