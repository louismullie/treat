class Treat::Loaders

  # A helper class to load a language class
  # registered with the Linguistics gem.
  class Linguistics

    silence_warnings { require 'linguistics' }
    @@languages = {}

    def self.load(language)
      if @@languages[language]
        return @@languages[language]
      end
      begin
        l = language.to_s.upcase
        silence_warnings do
          @@languages[language] =
          ::Linguistics.const_get(l)
        end
      rescue RuntimeError
        raise "Ruby Linguistics does " +
        "not have a module installed " +
        "for the #{language} language."
      end

    end

  end

end
