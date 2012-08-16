# Sentence segmentation based on a set of predefined
# rules defined in SRX (Segmentation Rules eXchange)
# format and developped by Marcin Milkowski.
#
# Original paper: Marcin Miłkowski, Jarosław Lipski,
# 2009. Using SRX standard for sentence segmentation
# in LanguageTool, in: Human Language Technologies
# as a Challenge for Computer Science and Linguistics.
class Treat::Workers::Processors::Segmenters::SRX

  @@segmenters = {}

  # Require the srx-english library.
  # Segment a text using the SRX algorithm
  def self.segment(entity, options = {})

    lang = entity.language
    entity.check_hasnt_children
    text = entity.to_s
    escape_floats!(text)

    unless @@segmenters[lang]
      # Require the appropriate gem.
      require "srx/#{lang}/sentence_splitter"
      @@segmenters[lang] = SRX.const_get(
      lang.capitalize).const_get(
      'SentenceSplitter')
    end

    sentences = @@segmenters[lang].new(text)

    sentences.each do |sentence|
      unescape_floats!(sentence)
      entity << Treat::Entities::Phrase.
      from_string(sentence.strip)
    end

    entity

  end

end
