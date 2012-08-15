# Stemming using a wrapper for a C implementation of the
# Porter stemming algorithm, a rule-based suffix-stripping
# stemmer which is very widely used and is considered the 
# de-facto standard algorithm used for English stemming.
#
# Original paper: Porter, 1980. An algorithm for suffix 
# stripping. Program, vol. 14, no. 3, p. 130-137.
class Treat::Workers::Inflectors::Stemmers::PorterC
  
  # Require the 'ruby-stemmer' gem.
  silence_warnings { require 'lingua/stemmer' }
  
  # Remove a conflict between this gem and the 'engtagger' gem.
  ::LinguaStemmer = ::Lingua
  Object.instance_eval { remove_const :Lingua }
  
  # Stem the word using a full-blown Porter stemmer in C.
  #
  # Options: none.
  def self.stem(word, options = {})
    ::LinguaStemmer.stemmer(word.to_s)
  end
  
end
