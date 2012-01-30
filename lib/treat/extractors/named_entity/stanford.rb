module Treat
  module Extractors
    module NamedEntity
      class Stanford
        require 'stanford-core-nlp'
        def self.named_entity(entity, options = {})
          if [:collection, :document, :section].include?(entity.type)
            
            entity.each_sentence do |x|
              self.named_entity(x, options)
            end
            
          else
            
            pipeline =  ::StanfordCoreNLP.load(:tokenize, :ssplit, :pos, :lemma, :parse, :ner)
            text = ::StanfordCoreNLP::Text.new(entity)
            pipeline.annotate(text)
            
            text.get(:sentences).each do |sentence|
              sentence.set :named_entity_tag, sentence.get(:named_entity_tag)
            end
            
          else
            
          end
          
        end
      end
    end
  end
end