module Treat
  module Processors
    module Tokenizers
      # A wrapper for the Stanford parser's Penn-Treebank
      # style tokenizer.
      class Stanford
        require 'stanford-core-nlp'
        DefaultOptions = {
          :silence => false, 
          :log_to_file => nil
        }
        @@tokenizer = nil
        # Tokenize the entity using a Penn-Treebank style tokenizer
        # included with the Stanford Parser.
        #
        # Options:
        # - (String) :log_to_file => a filename to log output to
        # instead of displaying it.
        def self.tokenize(entity, options = {})
          options = DefaultOptions.merge(options)
          options[:log_to_file] = '/dev/null' if options[:silence]
          if options[:log_to_file]
            ::StanfordCoreNLP.log_file = options[:log_to_file] 
          end
          @@tokenizer ||= ::StanfordCoreNLP.load(:tokenize)
          text = ::StanfordCoreNLP::Text.new(entity.to_s)
          @@tokenizer.annotate(text)
          text.get(:tokens).each do |token|
            t = Treat::Entities::Token.from_string(token.value)
            entity << t
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