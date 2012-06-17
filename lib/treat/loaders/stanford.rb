module Treat
  
  module Loaders

    class Stanford

      require 'stanford-core-nlp'
      
      @@loaded = false

      def self.load(language = nil)

        return if @@loaded

        language ||= Treat.core.language.default

        StanfordCoreNLP.jar_path = 
        Treat.paths.bin + "stanford/"
        StanfordCoreNLP.model_path = 
        Treat.paths.models + 'models/'
        StanfordCoreNLP.use(language)
        
        if Treat.core.verbosity.silence]
          StanfordCoreNLP.log_file = NULL_DEVICE 
        end
        
        StanfordCoreNLP.bind

        @@loaded = true

      end

    end
    
  end
  
end
