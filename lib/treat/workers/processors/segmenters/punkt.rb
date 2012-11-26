# Sentence segmentation based on a set of log-
# likelihood-based heuristics to infer abbreviations
# and common sentence starters from a large text
# corpus. Easily adaptable but requires a large 
# (unlabeled) indomain corpus for assembling statistics.
#
# Original paper: Kiss, Tibor and Strunk, Jan. 2006.
# Unsupervised Multilingual Sentence Boundary Detection.
# Computational Linguistics 32:485-525.
class Treat::Workers::Processors::Segmenters::Punkt
  
  # Require silently the punkt-segmenter gem.
  silence_warnings { require 'punkt-segmenter' }
  
  # Require the YAML parser.
  # silence_warnings { require 'psych' }
  
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
    
    entity.check_hasnt_children
    
    lang = entity.language
    set_options(lang, options)
    
   
    s = entity.to_s
    
    # Replace the point in all floating-point numbers
    # by ^^; this is a fix since Punkt trips on decimal 
    # numbers.
    s.escape_floats!
    
    # Take out suspension points temporarily.
    s.gsub!('...', '&;&.')
    # Remove abbreviations.
    s.scan(/(?:[A-Za-z]\.){2,}/).each do |abbr| 
      s.gsub!(abbr, abbr.gsub(' ', '').gsub('.', '&-&'))
    end
    # Unstick sentences from each other.
    s.gsub!(/([^\.\?!]\.|\!|\?)([^\s"'])/) { $1 + ' ' + $2 }
    
    result = @@segmenters[lang].
    sentences_from_text(s, 
    :output => :sentences_text)
    
    result.each do |sentence|
      # Unescape the sentence.
      sentence.unescape_floats!
      # Repair abbreviations in sentences.
      sentence.gsub!('&-&', '.')
      # Repair suspension points.
      sentence.gsub!('&;&.', '...')
      entity << Treat::Entities::Phrase.
        from_string(sentence)
    end
    
  end
  
  def self.set_options(lang, options)
    
    return @@segmenters[lang] if @@segmenters[lang]
    
    if options[:model]
      model = options[:model]
    else
      model_path = Treat.libraries.punkt.model_path || 
      Treat.paths.models + 'punkt/'
      model = model_path + "#{lang}.yaml"
      unless File.readable?(model)
        raise Treat::Exception,
        "Could not get the language model " +
        "for the Punkt segmenter for #{lang.to_s.capitalize}."
      end
    end
    
    t = ::YAML.load(File.read(model))

    @@segmenters[lang] =
    ::Punkt::SentenceTokenizer.new(t)
    
  end
  
end