module Treat
  module Lexicalizers
    module Tag
      class Tagger
        def self.tag(entity, options = {})
          if [:sentence, :phrase].include?(entity.type) && !entity.has_children?
            raise Treat::Exception,
            "Annotator 'tag' requires processor 'tokenize'."
          elsif entity.type == :word
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