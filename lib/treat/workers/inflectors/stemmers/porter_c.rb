# Stems words using the 'ruby-stemmer' gem, which
# wraps a C version of the Porter stemming algorithm.
#
# Project website: https://github.com/aurelian/ruby-stemmer
# Original paper: Porter, 1980. An algorithm for suffix stripping,
# Program, Vol. 14, no. 3, pp 130-137,
# Original C implementation: http://www.tartarus.org/~martin/PorterStemmer.
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
