module Treat
  module Extractors
    module Coreferences
      class Stanford
        require 'stanford-core-nlp'
        def self.named_entity(entity, options = {})
          pipeline =  ::StanfordCoreNLP.load(:tokenize, :ssplit, :pos, :lemma, :parse, :ner, :dcoref)
          text = ::StanfordCoreNLP::Text.new(entity)
          pipeline.annotate(text)
        end
      end
    end
  end
end