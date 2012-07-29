# A helper class to load the CoreNLP package.
class Treat::Loaders::Stanford

  require 'stanford-core-nlp'
  
  @@loaded = false

  # Load CoreNLP package for a given language.
  def self.load(language = nil)
    return if @@loaded
    language ||= Treat.core.language.default
    
    StanfordCoreNLP.jar_path = 
    Treat.libraries.stanford.jar_path || 
    Treat.paths.bin + 'stanford/'
    
    StanfordCoreNLP.model_path = 
    Treat.libraries.stanford.model_path || 
    Treat.paths.models + 'stanford/'
    
    StanfordCoreNLP.use(language)
    if Treat.core.verbosity.silence
      StanfordCoreNLP.log_file = NULL_DEVICE
    end
    
    StanfordCoreNLP.bind
    @@loaded = true
  end
  
end
