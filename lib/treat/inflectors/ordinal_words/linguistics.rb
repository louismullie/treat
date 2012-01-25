module Treat
  module Inflectors
    module OrdinalWords
      class Linguistics
        silence_warnings { require 'linguistics' }
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
