module Treat
  module Processors
    module Tokenizers
      # An adapter for the 'tokenizer' gem, which performs
      # rule-based tokenizing of texts in English, German
      # or French.
      class Multilingual
        # Hold one tokenizer per language.
        @@tokenizers = {}
        # Require the 'tokenizer' gem.
        silence_warnings { require 'tokenizer' }
        # Perform the tokenization of English, German or French text.
        # Options:
        # :language => (Symbol) Force a language for the tokenizer.
        def self.tokenize(entity, options = {})
          lang = options[:language] ? options[:language] : entity.language
          lang = Treat::Languages.find(lang, 1)    
          if @@tokenizers[lang].nil?
            @@tokenizers[lang] = ::Tokenizer::Tokenizer.new(lang)
          end
          tokens = @@tokenizers[lang].tokenize(entity.to_s)
          tokens.each do |token|
            next if token =~ /([[:space:]]+)/
            entity << Treat::Entities::Entity.from_string(token)
          end
          entity
        end
      end
    end
  end
end
