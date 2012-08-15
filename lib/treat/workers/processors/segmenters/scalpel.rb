# Sentence segmentation based on a set of predefined
# rules that handle a large number of usage cases of
# sentence enders. The idea is to remove all cases of
# .!? being used for other purposes than marking a
# full stop before naively segmenting the text.
class Treat::Workers::Processors::Segmenters::Scalpel

  require 'scalpel'
  
  # Segment a text using the Scalpel algorithm.
  def self.segment(entity, options = {})
    sentences = Scalpel.cut(entity.to_s)
    sentences.each do |sentence|
      entity << Treat::Entities::Phrase.
      from_string(sentence.strip)
    end
    entity
  end

end
