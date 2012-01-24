module Treat
  module Lexicalizers
    module Category
      # A class that detects the category of a word from its tag,
      # using the default tagger for the language of the entity.
      class FromTag
        # Find the category of the current entity.
        # Options:
        # :tagger => (Symbol) force the use of a tagger.
        # :tag_to_cat => (Hash) a list of categories for each possible tag.
        def self.category(entity, options = {})
          if options.empty?
            options = {
              tagger: nil,
              tag_to_cat: Treat::Resources::Tags::PTBWordTagToCategory
            }
          end
          tag = options[:tagger].nil? ? entity.tag : entity.tag(options[:tagger])
          cat = options[:tag_to_cat][tag]
          if cat.nil?
            warn "Category not found for tag #{tag}."
            :unknown
          else
            cat
          end
        end
      end
    end
  end
end
