module Treat
  module Lexicalizers
    module Category
      # A class that detects the category of a word from its tag,
      # using the default tagger for the language of the entity.
      class FromTag
        DefaultOptions = { tagger: nil }
        # Find the category of the current entity.
        # Options:
        # :tagger => (Symbol) force the use of a tagger.
        # :tag_to_cat => (Hash) a list of categories for each possible tag.
        def self.category(entity, options = {})
          options = DefaultOptions.merge(options)
          tag = options[:tagger].nil? ? entity.tag : entity.tag(options[:tagger])
          lang = Treat::Languages.get(entity.language)
          cat = lang::WordTagToCategory[tag]
          if cat.nil?
            warn "Category not found for tag #{tag}."
            :unknown
          else
            if cat.size == 1
              return cat[0]
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
