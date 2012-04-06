class Treat::Loaders

  # A helper class to load a language class
  # registered with the Linguistics gem.
  class Stanford

    require 'stanford-core-nlp'
    
    StanfordCoreNLP.jar_path = 
    Treat.bin + 'stanford/'
    
    StanfordCoreNLP.model_path = 
    Treat.models + 'stanford/'
    
    StanfordCoreNLP.use(
    Treat::Languages.describe(
    Treat.default_language))

    StanfordCoreNLP.log_file = 
    NULL_DEVICE if Treat.silence
    
    StanfordCoreNLP.bind
    @@loaded = true
    
  end

end