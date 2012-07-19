# A helper class to load a language class
# registered with the Linguistics gem.
class Treat::Loaders::Linguistics

  # Linguistics throws warnings; silence them.
  silence_warnings { require 'linguistics' }

  # Linguistics classes for each language.
  @@languages = {}

  # Load the Linguistics class that corresponds
  # to the supplied language; raises an exception
  # if there is no such language class registered.
  def self.load(language)
    silence_warnings do
      @@languages[language] ||= 
      ::Linguistics.const_get(
      language.to_s[0..1].upcase)
    end
    return @@languages[language]
  rescue RuntimeError
    raise Treat::Exception,
    "Ruby Linguistics does " +
    "not have a module installed " +
    "for the #{language} language."
  end

end
