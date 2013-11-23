require_relative 'bind_it'

# A helper class to load the CoreNLP package.
class Treat::Loaders::Stanford < Treat::Loaders::BindIt
  
  def self.load(language = nil)
    require 'stanford-core-nlp'
    super(StanfordCoreNLP, :stanford, language)
  end

  def self.find_model(name, language)
    language = language.intern
    model_file = StanfordCoreNLP::Config::Models[name][language]
    model_dir  = StanfordCoreNLP::Config::ModelFolders[name]
    model_path = Treat.libraries.stanford.model_path ||
    File.join(Treat.paths.models, 'stanford')
    File.join(model_path, model_dir, model_file)
  end

end