module Treat
  module Extractors
    module NamedEntityTag
      class Stanford
        require 'stanford-core-nlp'
        StanfordCoreNLP.load_class('ArrayList', 'java.util')
        StanfordCoreNLP.load_class('Word', 'edu.stanford.nlp.ling')
        @@pipeline = nil
        def self.named_entity_tag(entity, options = {})
          pp = nil
          if entity.is_a?(Treat::Entities::Token) && 
             entity.has_parent?
              pp = entity.parent_phrase
              s = get_list(pp.tokens)
          else
            s = entity.to_s
          end
          
          @@pipeline ||=  ::StanfordCoreNLP.load(
          :tokenize, :ssplit, :pos, :lemma, :parse, :ner
          )
          
          text = ::StanfordCoreNLP::Text.new(s)
          @@pipeline.annotate(text)
          
          add_to = pp ? pp : entity
          
          if entity.is_a?(Treat::Entities::Phrase)
            text.get(:tokens).each do |token|
              t = Treat::Entities::Token.from_string(token.value.to_s)
              tag = token.get(:named_entity_tag).to_s.downcase
              t.set :named_entity_tag, tag.intern unless tag == 'o'
              add_to << t
            end
          elsif entity.is_a?(Treat::Entities::Token)
            tag = text.get(:tokens).iterator.next.
            get(:named_entity_tag).to_s.downcase
            entity.set :named_entity_tag, tag.intern unless tag == 'o'
          end
          
        end

        def self.get_list(words)
          list = StanfordCoreNLP::ArrayList.new
          words.each do |w|
            list.add(StanfordCoreNLP::Word.new(w.to_s))
          end
          list
        end
      end
    end
  end
end
