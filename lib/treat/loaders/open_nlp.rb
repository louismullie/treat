require 'treat/loaders/bind_it'

# A helper class to load the OpenNLP package.
class Treat::Loaders::OpenNLP < Treat::Loaders::BindIt
  
  require 'open-nlp'
  
  def self.load(language = nil)
    super(OpenNLP, :open_nlp, language)
  end

end