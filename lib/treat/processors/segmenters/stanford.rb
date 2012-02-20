# A wrapper for the sentence splitter supplied by
# the Stanford parser.
class Treat::Processors::Segmenters::Stanford

  # Require bindings for the Stanford Core NLP package.
  require 'stanford-core-nlp'

  # By default, run verbosely.
  DefaultOptions = {
    :silence => false,
    :log_file => false,
    :also_tokenize => false
  }

  # Keep one copy of the Stanford Core NLP pipeline.
  @@segmenter = nil

  # Segment sentences using the sentence splitter 
  # supplied by the Stanford parser. For better 
  # performance, set the option :also_tokenize 
  # to true, and this segmenter will also add
  # the tokens as children of the sentences.
  #
  # Options:
  #
  # - (Boolean) :also_tokenize - Whether to also 
  # add the tokens as children of the sentence.
  # - (String) :log_file => a filename to log 
  # output to, instead of displaying it.
  # - (String) :silence => send output to /dev/null.
  def self.segment(entity, options = {})
    
    entity.check_hasnt_children
    
    options = get_options(options)
    @@segmenter ||=  
    ::StanfordCoreNLP.load(:tokenize, :ssplit)
    text = ::StanfordCoreNLP::Text.new(entity.to_s)
    @@segmenter.annotate(text)
    text.get(:sentences).each do |sentence|
      s = Treat::Entities::Sentence.
      from_string(sentence.to_s, true)
      entity << s
      if options[:also_tokenize]
        Treat::Processors::Tokenizers::Stanford.
        add_tokens(s, sentence.get(:tokens))
      end
    end
  end

  # Helper method to parse options and 
  # set configuration values.
  def self.get_options(options)
    options = DefaultOptions.merge(options)
    if options[:silence]
      options[:log_file] = '/dev/null' 
    end
    if options[:log_file]
      ::StanfordCoreNLP.log_file = 
      options[:log_file]
    end
    options
  end
  
end