# Tokenization provided by Stanford Penn-Treebank style 
# tokenizer. Most punctuation is split from adjoining words,
# double quotes (") are changed to doubled single forward- 
# and backward- quotes (`` and ''), verb contractions and 
# the Anglo-Saxon genitive of nouns are split into their 
# component morphemes, and each morpheme is tagged separately.
class Treat::Workers::Processors::Tokenizers::Stanford

  require 'treat/loaders/stanford'
  Treat::Loaders::Stanford.load
  
  @@tokenizer = nil

  # Perform tokenization of the entity and add
  # the resulting tokens as its children.
  #
  # Options: none.
  def self.tokenize(entity, options = {})
    entity.check_hasnt_children
    @@tokenizer ||=
    ::StanfordCoreNLP.load(:tokenize)
    text = ::StanfordCoreNLP::
    Text.new(entity.to_s)
    @@tokenizer.annotate(text)
    add_tokens(entity, text.get(:tokens))
  end

  # Add the tokens to the entity.
  def self.add_tokens(entity, tokens)
    tokens.each do |token|
      val = token.value
      # FIXME - other special chars
      val = '(' if val == '-LRB-'
      val = ')' if val == '-RRB'
      entity << Treat::Entities::Token.
      from_string(token.value)
    end
  end

end
