module Treat
  module Lexicalizers
    module Tag
      class Stanford
        require 'stanford-core-nlp'
        # Hold one tagger per language.
        @@taggers = {}
        # Hold the default options.
        DefaultOptions =  {
          :tagger_model => nil,
          :silence => false, 
          :log_to_file => nil
        }
        LanguageToTagSet = {
          :eng => :penn,
          :ger => :negra,
          :chi => :penn_chinese,
          :fre => :simple
        }
        # Tag the word using one of the Stanford taggers.
        def self.tag(entity, options = {})
          # Handle options and set models.
          options = DefaultOptions.merge(options)
          if entity.has_children?
            warn "The Stanford tagger performs its own tokenization." +
                 "Removing all children of #{entity.type} with value #{entity.short_value}."
            entity.remove_all!
          end
          # Arrange options.
          lang = entity.language
          tag_set = LanguageToTagSet[lang]
          warn "The tag set for the Stanford tagger you are requiring is not supported." unless tag_set
          ::StanfordCoreNLP.set_model('pos.model', options[:tagger_model]) if options[:tagger_model]
          options[:log_to_file] = '/dev/null' if options[:silence]
          ::StanfordCoreNLP.log_file = options[:log_to_file]  if options[:log_to_file]
          
          # Load the tagger.
          StanfordCoreNLP.use(lang)
          @@taggers[lang] ||= ::StanfordCoreNLP.load(:tokenize, :ssplit, :pos)
          
          # Tag the text.
          text = ::StanfordCoreNLP::Text.new(entity.to_s)
          isolated_word = entity.is_a?(Treat::Entities::Token)
          @@taggers[lang].annotate(text)
          
          text.get(:tokens).each do |token|
            val = token.get(:value).to_s
            tok = Treat::Entities::Token.from_string(val)
            tag = token.get(:part_of_speech).to_s
            tag_s, tag_opt = *tag.split('-')
            tag_s ||= ''
            tok.set :tag, tag_s
            tok.set :tag_opt, tag_opt
            tok.set :tag_set, tag_set if tag_set
            if isolated_word
              entity.set :tag_set, :penn
              return tag_s
            end
            entity << tok
          end
          
          # Handle tags for sentences and phrases.
          entity.set :tag_set, tag_set if tag_set
          return 'P' if entity.is_a?(Treat::Entities::Phrase)
          return 'S' if entity.is_a?(Treat::Entities::Sentence)
        end
      end
    end
  end
end
