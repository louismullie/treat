module Treat
  module Inflectors
    module Stemmers
      # Stems words using the 'ruby-stemmer' gem, which
      # wraps a C version of the Porter stemming algorithm.
      # 
      # Project website: https://github.com/aurelian/ruby-stemmer
      # Original paper: Porter, 1980. An algorithm for suffix stripping, 
      # Program, Vol. 14, no. 3, pp 130-137,
      # Original C implementation: http://www.tartarus.org/~martin/PorterStemmer.
      class PorterC
        silently { require 'lingua/stemmer' }
        ::LinguaStemmer = ::Lingua
        Object.instance_eval { remove_const :Lingua }
        # Stem the word using the Porter C algorithm.
        # Options: none.
        def self.stem(word, options = {})
          silently { ::LinguaStemmer.stemmer(word.to_s) }
        end
      end
    end
  end
end
