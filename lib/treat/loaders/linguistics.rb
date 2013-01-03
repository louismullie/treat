# A helper class to load a language class
# registered with the Linguistics gem, for
# example Linguistics::EN.
class Treat::Loaders::Linguistics

  # Linguistics classes for each language.
  @@languages = {}

  # Load the Linguistics class that corresponds
  # to the supplied language; raises an exception
  # if there is no such language class registered.
  def self.load(language)
    code = language.to_s[0..1].intern # FIX
    unless @@languages[language]
      require 'linguistics'
      Linguistics.use(code)
      @@languages[language] = true
    end
    code
  rescue RuntimeError
    raise Treat::Exception,
    "Ruby Linguistics does not have a module " +
    "installed for the #{language} language."
  end

end
