# A wrapper for the sentence splitter supplied by
# the Stanford parser.
class Treat::Processors::Segmenters::Stanford

  require 'treat/loaders/stanford'
  Treat::Loaders::Stanford.load
  
  DefaultOptions = {
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
  def self.segment(entity, options = {})

    options = DefaultOptions.merge(options)
    entity.check_hasnt_children

    @@segmenter ||=
    ::StanfordCoreNLP.load(:tokenize, :ssplit)
    
    s = entity.to_s
    
    text = ::StanfordCoreNLP::Text.new(entity.to_s)

    @@segmenter.annotate(text)
    text.get(:sentences).each do |sentence|
      sentence = sentence.to_s
      s = Treat::Entities::Sentence.
      from_string(sentence, true)
      entity << s
      if options[:also_tokenize]
        Treat::Processors::Tokenizers::Stanford.
        add_tokens(s, sentence.get(:tokens))
      end
    end

  end

end
