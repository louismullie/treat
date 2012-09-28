# Tokenization provided by Stanford Penn-Treebank style 
# tokenizer. Most punctuation is split from adjoining words,
# verb contractions and the Anglo-Saxon genitive of nouns are 
# split into their component morphemes, and each morpheme is 
# tagged separately. N.B. Contrary to the standard PTB 
# tokenization, double quotes (") are NOT changed to doubled 
# single forward- and backward- quotes (`` and '') by default.
class Treat::Workers::Processors::Tokenizers::Stanford

  require_relative 'treat/loaders/stanford'
  Treat::Loaders::Stanford.load
  
  # Default options for the tokenizer.
  DefaultOptions = {
    directional_quotes: false,
    escape_characters: false
  }
  
  # Hold one instance of the tokenizer.
  @@tokenizer = nil

  # Perform tokenization of the entity and add
  # the resulting tokens as its children.
  #
  # Options:
  # - (Boolean) :directional_quotes => Whether
  # to attempt to get correct directional quotes,
  # replacing "..." by ``...''. Off by default.
  def self.tokenize(entity, options = {})
    options = DefaultOptions.merge(options)
    entity.check_hasnt_children
    @@tokenizer ||=
    ::StanfordCoreNLP.load(:tokenize)
    text = ::StanfordCoreNLP::
    Text.new(entity.to_s)
    @@tokenizer.annotate(text)
    add_tokens(entity, text.get(:tokens), options)
  end

  # Add the tokens to the entity.
  def self.add_tokens(entity, tokens, options)
    tokens.each do |token|
      val = token.value
       unless options[:escape_characters]
         Treat.tags.ptb.escape_characters.
            each do |key, value|
             val.gsub!(value, key)
           end
       end
      unless options[:directional_quotes]
        val.gsub!(/``/,'"') 
        val.gsub!(/''/,'"')
      end
      entity << Treat::Entities::Token.
      from_string(val)
    end
  end

end
