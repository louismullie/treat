# Sentence segmentation based on a Naive Bayesian
# statistical model. Trained on Wall Street Journal 
# news combined with the Brown Corpus, which is 
# intended to be widely representative of written English.
#
# Original paper: Dan Gillick. 2009. Sentence Boundary 
# Detection and the Problem with the U.S. University 
# of California, Berkeley (http://bit.ly/O2W48F).
class Treat::Workers::Processors::Segmenters::Tactful
  
  # Require the 'tactful_tokenizer' gem.
  silence_warnings { require 'tactful_tokenizer' }
  
  # Remove function definition 'tactful_tokenizer' by gem.
  String.class_eval { undef :tokenize }
  
  # Keep only one copy of the segmenter.
  @@segmenter = nil
  
  # Segment a text or zone into sentences
  # using the 'tactful_tokenizer' gem.
  #
  # Options: none.
  def self.segment(entity, options = {})

    entity.check_hasnt_children
    
    s = entity.to_s
    
    escape_floats!(s)
    
    s.gsub!(/([^\.\?!]\.|\!|\?)([^\s"'])/) { $1 + ' ' + $2 }
    
    @@segmenter ||= TactfulTokenizer::Model.new
   
    sentences = @@segmenter.tokenize_text(s)
    
    sentences.each do |sentence|
      unescape_floats!(sentence)
      entity << Treat::Entities::Phrase.from_string(sentence)
    end
    
  end
  
end