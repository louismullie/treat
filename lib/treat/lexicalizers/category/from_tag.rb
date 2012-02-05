module Treat
  module Lexicalizers
    module Category
      # A class that detects the category of a word from its tag,
      # using the default tagger for the language of the entity.
      class FromTag
        # Find the category of the current entity.
        #
        # Options:
        #
        # - (Symbol) :tagger => force the use of a tagger.
        def self.category(entity, options = {})
          tag = entity.tag
          return :unknown if tag.nil? || tag == ''
          return :sentence if tag == 'S'
          if entity.is_a?(Treat::Entities::Phrase)
            cat = Treat::Languages::Tags::PhraseTagToCategory[tag]
            unless cat
              cat = Treat::Languages::Tags::WordTagToCategory[tag]
            end
          elsif entity.is_a?(Treat::Entities::Word)
            cat = Treat::Languages::Tags::WordTagToCategory[tag]
          end
          if cat == nil
            warn "Category not found for tag '#{tag}'."
            return :unknown
          else
            if cat.size == 1
              return cat[entity.tag_set]
            else
              if entity.has?(:tag_set)
                if cat[entity.tag_set]
                  return cat[entity.tag_set]
                else
                  raise Treat::Exception,
                  "The specified tag set (#{entity.tag_set})" +
                  " does not contain the tag #{tag}."
                end
              else
                raise Treat::Exception,
                "No information can be found regarding which tag set to use."
              end
            end
          end
        end
      end
    end
  end
end
