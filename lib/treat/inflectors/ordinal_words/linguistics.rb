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
          begin
            l = number.language.to_s.upcase
            delegate = nil
            silence_warnings { delegate = ::Linguistics.const_get(l) }
          rescue RuntimeError
            lang = Treat::Languages.describe(number.language)
            raise "Ruby Linguistics does not have a module " +
            " installed for the #{lang} language."
          end
          silence_warnings { delegate.ordinate(number.to_s) }
        end
      end
    end
  end
end
