require 'treat/loaders/bind_it'

# A helper class to load the OpenNLP package.
class Treat::Loaders::OpenNLP < Treat::Loaders::BindIt
  
  def self.load(language = nil)
    require 'open-nlp'
    super(OpenNLP, :open_nlp, language)
  end

end