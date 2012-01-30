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
          tag = options[:tagger].nil? ? 
          entity.tag : entity.tag(options[:tagger])
          lang = Treat::Languages.get(entity.language)
          if entity.type == :sentence
            cat = lang::SentenceTags[entity.tag_set]
            unless cat
              raise Treat::Exception,
              "'#{entity.tag} is not a valid sentence tag."
            end
            return cat
          elsif entity.type == :phrase
            cat = lang::PhraseTagToCategory[tag]
          elsif entity.type == :word
            cat = lang::WordTagToCategory[tag]
          end
          cat ||= ''
          if cat == ''
            warn "Category not found for tag '#{tag}'." 
            :unknown
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
