# A wrapper for the Stanford parser's
# Penn-Treebank style tokenizer.
class Treat::Processors::Tokenizers::Stanford

  require 'treat/loaders/stanford'

  @@tokenizer = nil

  # Tokenize the entity using a Penn-Treebank
  # style tokenizer.
  #
  # Options: none.
  def self.tokenize(entity, options = {})

    entity.check_hasnt_children

    s = entity.to_s
    
    @@tokenizer ||=
    ::StanfordCoreNLP.load(:tokenize)
    text =
    ::StanfordCoreNLP::Text.new(s)
    @@tokenizer.annotate(text)

    add_tokens(entity, text.get(:tokens))

  end

  # Add the tokens to the entity.
  def self.add_tokens(entity, tokens)
    tokens.each do |token|
      val = token.value
      val = '(' if val == '-LRB-'     # Fix for other special chars
      val = ')' if val == '-RRB'
      t = Treat::Entities::Token.
      from_string(token.value)
      entity << t
    end
  end

end
