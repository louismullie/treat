module Treat
  module Lexicalizers
    module Tag
      class Tagger
        def self.tag(entity, options = {})
          if (entity.is_a?(Treat::Entities::Sentence) ||
             entity.is_a?(Treat::Entities::Phrase)) && 
             !entity.has_children?
              raise Treat::Exception,
              "Annotator 'tag' requires processor 'tokenize'."
          elsif entity.is_a?(Treat::Entities::Word)
            if entity.has_parent?
              ps = entity.parent_sentence
              pp = entity.parent_phrase
              if ps
                self.tag(ps, options)
              elsif pp
                self.tag(pp, options)
              end
              return entity.features[:tag]
            else
              return :isolated_word
            end
          end
        end
      end
    end
  end
end