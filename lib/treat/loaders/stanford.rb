class Treat::Loaders

  # A helper class to load a language class
  # registered with the Linguistics gem.
  class Stanford

    @@loaded = false

    def self.load
      return if @@loaded
      require 'stanford-core-nlp'
      StanfordCoreNLP.jar_path = '/ruby/gems/treat/bin/stanford/'
      StanfordCoreNLP.model_path = Treat.models + 'stanford/'
      StanfordCoreNLP.log_file = NULL_DEVICE
      @@loaded = true
    end

  end

end
