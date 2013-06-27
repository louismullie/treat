# Detects sentence boundaries by first tokenizing the
# text and deciding whether periods are sentence ending 
# or used for other purposes (abreviations, etc.).  The  
# obtained tokens are then grouped into sentences.
class Treat::Workers::Processors::Segmenters::Stanford

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

    Treat::Loaders::Stanford.load

    options = DefaultOptions.merge(options)
    entity.check_hasnt_children

    @@segmenter ||=
    ::StanfordCoreNLP.load(:tokenize, :ssplit)
    
    s = entity.to_s
    text = ::StanfordCoreNLP::Annotation.new(s)

    @@segmenter.annotate(text)
    text.get(:sentences).each do |sentence|
      sentence = sentence.to_s
      s = Treat::Entities::Sentence.
      from_string(sentence, true)
      entity << s
      if options[:also_tokenize]
        Treat::Workers::Processors::Tokenizers::Stanford.
        add_tokens(s, sentence.get(:tokens))
      end
    end

  end

end
