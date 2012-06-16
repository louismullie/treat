module Treat
  
  module Loaders

    class Stanford

      require 'stanford-core-nlp'

      class << self
        attr_accessor :jar_path
        attr_accessor :model_path
        attr_accessor :loaded
      end

      self.jar_path = Treat.bin + 'stanford/'
      self.model_path = Treat.models + 'stanford/'
      self.loaded = false

      def self.load(language = nil)

        return if self.loaded

        language ||= Treat.core.language.default

        StanfordCoreNLP.jar_path = self.jar_path
        StanfordCoreNLP.model_path = self.model_path

        StanfordCoreNLP.use(language)

        StanfordCoreNLP.log_file =
        NULL_DEVICE if Treat.core.verbosity[:silence?]

        StanfordCoreNLP.bind

        self.loaded = true

      end

    end
    
  end
  
end
