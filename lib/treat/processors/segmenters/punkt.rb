# An adapter for the 'punk-segmenter' gem, which segments
# texts into sentences based on an unsupervised, language
# independent algorithm.
#
# Original paper: Kiss, Tibor and Strunk, Jan (2006):
# Unsupervised Multilingual Sentence Boundary Detection.
# Computational Linguistics 32: 485-525.
module Treat::Processors::Segmenters::Punkt

  # Require silently the punkt-segmenter gem.
  silence_warnings { require 'punkt-segmenter' }
  # Require the YAML parser.
  silence_warnings { require 'psych' }
  
  # Hold one copy of the segmenter per language.
  @@segmenters = {}
  
  # Hold only one trainer per language.
  @@trainers = {}
  
  # Segment a text using the Punkt segmenter gem.
  # The included models for this segmenter have 
  # been trained on one or two lengthy books 
  # from the corresponding language.
  # 
  # Options:
  #
  # (String) :training_text => Text to train on.
  def self.segment(entity, options = {})
    
    Treat::Processors.warn_if_has_children(entity)
    
    lang = entity.language
    set_options(lang, options)
    s = entity.to_s
    
    s.gsub!(/([^\.\?!]\.|\!|\?)([^\s])/) { $1 + ' ' + $2 }
    
    result = @@segmenters[lang].
    sentences_from_text(s, :output => :sentences_text)
    
    result.each do |sentence|
      entity << Treat::Entities::Phrase.
        from_string(sentence)
    end
    
  end
  
  def self.set_options(lang, options)
    return @@segmenters[lang] if @@segmenters[lang]
    if options[:model]
      model = options[:model]
    else
      l = Treat::Languages.describe(lang)
      model = "treat/processors/segmenters/punkt/#{l}.yaml"
      unless File.readable?(model)
        raise Treat::Exception,
        "Could not get the language model " +
        "for the Punkt segmenter for #{l}."
      end
    end
    
    t = ::Psych.load(File.read(model))
    @@segmenters[lang] =
    ::Punkt::SentenceTokenizer.new(t)
    
  end
  
end