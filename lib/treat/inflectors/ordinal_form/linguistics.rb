# This class is a wrapper for the functions included
# in the 'linguistics' gem that allow to describe a
# number in words in ordinal form.
#
# Project website: http://deveiate.org/projects/Linguistics/
class Treat::Inflectors::OrdinalForm::Linguistics

  require 'treat/loaders/linguistics'
  
  # Desribe a number in words in ordinal form, using the
  # 'linguistics' gem.
  def self.ordinal_form(number, options = {})
    klass = Treat::Loaders::Linguistics.load(number.language)
    klass.ordinate(number.to_s)
  end
  
end