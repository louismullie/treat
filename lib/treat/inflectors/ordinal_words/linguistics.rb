module Treat
  module Inflectors
    module OrdinalWords
      class Linguistics
        silently { require 'linguistics' }
        def self.ordinal_words(number, options = {})
          begin
            l = number.language.to_s.upcase
            delegate = nil
            silently { delegate = ::Linguistics.const_get(l) }
          rescue RuntimeError
            lang = Treat::Resources::Language.describe(number.language)
            raise "Ruby Linguistics does not have a module " +
            " installed for the #{lang} language."
          end
          silently { delegate.ordinate(number.to_s) }
        end
      end
    end
  end
end
