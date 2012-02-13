# A wrapper for the Stanford parser's
# Penn-Treebank style tokenizer.
class Treat::Processors::Tokenizers::Stanford

  # Require the Stanford Core NLP Java bindings.
  require 'stanford-core-nlp'

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
  # - (String) :log_to_file => a filename to 
  # log output to instead of displaying it.
  def self.tokenize(entity, options = {})
    
    Treat::Processors.warn_if_has_children(entity)
    
    set_options(options)
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

  # A helper method to set options.
  def self.set_options(options)
    
    options = DefaultOptions.merge(options)
    options[:log_file] = '/dev/null' if options[:silence]
    if options[:log_file]
      ::StanfordCoreNLP.log_file = options[:log_file]
    end
    
  end
  
end
