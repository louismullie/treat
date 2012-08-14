# Sentence segmentation based on a set of predefined 
# rules defined in SRX (Segmentation Rules eXchange)
# format and developped by Marcin Milkowski.
#
# Original paper: Marcin Miłkowski, Jarosław Lipski, 
# 2009. Using SRX standard for sentence segmentation 
# in LanguageTool, in: Human Language Technologies 
# as a Challenge for Computer Science and Linguistics.
class Treat::Workers::Processors::Segmenters::SRX
  
  # Require the srx-english library.
  require 'srx/english/sentence_splitter'

  # Segment a text using the SRX algorithm
  def self.segment(entity, options = {})
    
    entity.check_hasnt_children
    text = entity.to_s
    escape_floats!(text)
    
    sentences = SRX::English::
    SentenceSplitter.new(text)
    
    sentences.each do |sentence|
      unescape_floats!(sentence)
      entity << Treat::Entities::Phrase.
      from_string(sentence.strip)
    end
    
    entity
    
  end

end