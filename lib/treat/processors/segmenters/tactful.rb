# An adapter for the 'tactful_tokenizer' gem, which
# detects sentence boundaries based on a Naive Bayesian
# statistical model.
#
# Project website: https://github.com/SlyShy/Tackful-Tokenizer
#
# Original paper: Dan Gillick. 2009. Sentence Boundary Detection
# and the Problem with the U.S. University of California, Berkeley.
# http://dgillick.com/resource/sbd_naacl_2009.pdf
module Treat::Processors::Segmenters::Tactful
  
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
    
    Treat::Processors.warn_if_has_children(entity)
    
    @@segmenter ||= TactfulTokenizer::Model.new
    s = entity.to_s
    s.gsub!(/([^\.\?!]\.|\!|\?)([^\s])/) { $1 + ' ' + $2 }
    sentences = @@segmenter.tokenize_text(s)
    sentences.each do |sentence|
      entity << Treat::Entities::Phrase.from_string(sentence)
    end
  end
  
end