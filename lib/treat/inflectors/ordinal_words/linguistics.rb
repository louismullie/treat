module Treat
  module Inflectors
    module OrdinalWords
      # This class is a wrapper for the functions included
      # in the 'linguistics' gem that allow to describe a
      # number in words in ordinal form.
      #
      # Project website: http://deveiate.org/projects/Linguistics/
      class Linguistics
        # Require Ruby Linguistics.
        silence_warnings { require 'linguistics' }
        # Desribe a number in words in ordinal form, using the
        # 'linguistics' gem.
        def self.ordinal_words(number, options = {})
          silence_warnings { ::Linguistics::EN.ordinate(number.to_s) }
        end
      end
    end
  end
end
