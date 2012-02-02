module Treat
  module Extractors
    module NamedEntityTag
      class Stanford
        require 'stanford-core-nlp'
        @@pipeline = nil
        def self.named_entity_tag(entity, options = {})
          if entity.has_children?
            entity.print_tree
            raise Treat::Exception,
            "The Stanford Named Entity Recognizer must do its own tokenizing and parsing of sentences."
          end
          @@pipeline ||=  ::StanfordCoreNLP.load(:tokenize, :ssplit, :pos, :lemma, :parse, :ner)
          text = ::StanfordCoreNLP::Text.new(entity.to_s)
          @@pipeline.annotate(text)
          text.get(:tokens).each do |token|
            t = Treat::Entities::Token.from_string(token.value.to_s)
            tag = token.get(:named_entity_tag).to_s.downcase
            t.set :named_entity_tag, tag.intern unless tag == 'o'
            entity << t
          end
        end
      end
    end
  end
end
