# A helper class to load the 
# Stanford Core NLP package.
class Treat::Loaders::Stanford

  require 'stanford-core-nlp'
  @@loaded = false

  def self.load(language = nil)
    return if @@loaded
    language ||= Treat.core.language.default
    jar_path = Treat.libraries.
    stanford.jar_path || Treat.paths.bin
    models_path = Treat.libraries.
    stanford.model_path || Treat.paths.models
    StanfordCoreNLP.jar_path =
    "#{jar_path}stanford/"
    StanfordCoreNLP.model_path =
    "#{models_path}stanford/"
    StanfordCoreNLP.use(language)
    if Treat.core.verbosity.silence
      StanfordCoreNLP.log_file = NULL_DEVICE
    end
    StanfordCoreNLP.bind
    @@loaded = true
  end
  
end
