module Treat
  module Processors
    module Segmenters
      # A wrapper for the sentence splitter supplied by
      # the Stanford parser.
      class Stanford
        require 'stanford-core-nlp'
        DefaultOptions = { 
          :silence => false, 
          :log_to_file => false, 
          :also_tokenize => false 
        }
        # Segment sentences using the sentence splitter supplied by
        # the Stanford parser. By default, this segmenter also adds
        # the tokens as children of the sentences.
        #
        # Options:
        # - (Boolean) :also_tokenize - Whether to also add the tokens
        # as children of the sentence.
        # - (String) :log_to_file => a filename to log output to
        # instead of displaying it.
        # - (String) :silence => send 
        def self.segment(entity, options = {})
          options = DefaultOptions.merge(options)
          options[:log_to_file] = '/dev/null' if options[:silence]
          if options[:log_to_file]
            ::StanfordCoreNLP.log_file = options[:log_to_file] 
          end
          options = DefaultOptions.merge(options)
          pipeline =  ::StanfordCoreNLP.load(:tokenize, :ssplit)
          text = ::StanfordCoreNLP::Text.new(entity.to_s)
          pipeline.annotate(text)
          text.get(:sentences).each do |sentence|
            s = Treat::Entities::Sentence.from_string(sentence.to_s, true)
            entity << s
            if options[:also_tokenize]
              sentence.get(:tokens).each do |token|
                t = Treat::Entities::Phrase.from_string(token.value)
                s << t
                t.set :character_offset_begin, 
                token.get(:character_offset_begin)
                
                t.set :character_offset_end, 
                token.get(:character_offset_end)
              end
            end
          end
        end
      end
    end
  end
end
