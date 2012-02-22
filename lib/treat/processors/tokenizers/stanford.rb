# A wrapper for the Stanford parser's
# Penn-Treebank style tokenizer.
class Treat::Processors::Tokenizers::Stanford

  require 'treat/loaders/stanford'
  Treat::Loaders::Stanford.load

  # By default, run verboselu.
  DefaultOptions = {
    :silence => false,
    :log_file => nil
  }

  @@tokenizer = nil

  # Tokenize the entity using a Penn-Treebank
  # style tokenizer.
  #
  # Options:
  # - (String) :log_to_file => a filename to
  # log output to instead of displaying it.
  def self.tokenize(entity, options = {})

    entity.check_hasnt_children

    set_options(options)
    @@tokenizer ||= ::StanfordCoreNLP.load(:tokenize)

    text = ::StanfordCoreNLP::Text.new(entity.to_s)
    @@tokenizer.annotate(text)

    add_tokens(entity, text.get(:tokens))

  end

  # Add the tokens to the entity.
  def self.add_tokens(entity, tokens)
    tokens.each do |token|
      t = Treat::Entities::Token.from_string(token.value)
      entity << t
    end
  end
  
  # A helper method to set options.
  def self.set_options(options)

    options = DefaultOptions.merge(options)
    options[:log_file] = '/dev/null' if options[:silence]
    if options[:log_file]
      ::StanfordCoreNLP.log_file = options[:log_file]
    end

  end

end