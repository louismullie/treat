module Treat
  module Lexicalizers
    module Tag
      class Stanford < Tagger
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
          r = super(entity, options)
          return r if r && r != :isolated_word
          # Arrange options.
          lang = entity.language
          @@tag_set = LanguageToTagSet[lang]
          unless @@tag_set
            warn "The tag set for the tagger you are requiring is not supported."
          end
          
          if options[:tagger_model]
            ::StanfordCoreNLP.set_model(
              'pos.model', options[:tagger_model]
            )
          end
          if options[:silence]
            options[:log_to_file] = '/dev/null'
          end
          if options[:log_to_file]
            ::StanfordCoreNLP.log_file = 
              options[:log_to_file] 
          end
          
          # Load the tagger.
          StanfordCoreNLP.use(lang)
          @@taggers[lang] ||= ::StanfordCoreNLP.load(:tokenize, :ssplit, :pos)
          # Tag the text.
          text = ::StanfordCoreNLP::Text.new(entity.to_s)
          @@taggers[lang].annotate(text)
          # Realign the tags.
          entity.each_token do |t1|
            text.get(:sentences).each do |sentence|
              sentence.get(:tokens).each do |t2|
                if t2.value == t1.value
                  tag = t2.get(:part_of_speech).to_s
                  tag_s, tag_opt = *tag.split('-')
                  tag_s ||= ''
                  t1.set :tag, tag_s
                  t1.set :tag_opt, tag_opt
                  t1.set :tag_set, @@tag_set if @@tag_set
                  return tag_s if r == :isolated_word
                  break
                end
              end
            end
          end
          
          # Handle tags for sentences and phrases.
          entity.set :tag_set, @@tag_set if @@tag_set
          return 'P' if entity.is_a?(Treat::Entities::Phrase)
          return 'S' if entity.is_a?(Treat::Entities::Sentence)
        end
      end
    end
  end
end
