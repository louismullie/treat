module Treat
  # Algorithms to retrieve the inflections of a word. 
  # Stemmers return the stem (not root form) of a word. 
  # Taggers return the part of speech tag of a word. 
  # Inflectors allow to retrieve the different inflections of a
  # noun (declensions), a verb (conjugations). Lexicons return, 
  # among other things, the gloss or synset of a word. 
  module Inflectors
    # Lemmatizers return the root form of a word.
    module Lemmatizers
      extend Group
      self.type = :annotator
      self.targets = [:word]
    end
    # Stemmers return the stem (*not root form*) of a word.
    module Stemmers
      extend Group
      self.type = :annotator
      self.targets = [:word]
    end
    # Declensors allow to retrieve the different declensions of a
    # noun (singular, plural).
    module Declensors
      extend Group
      self.type = :annotator
      self.targets = [:word]
    end
    # Conjugators allow to retrieve the different conjugations of
    # a word.
    module Conjugators
      extend Group
      self.type = :annotator
      self.targets = [:word]
    end
    # Cardinal retrieve the full text description of a number.
    module CardinalWords
      extend Group
      self.type = :annotator
      self.targets = [:number]
    end
    # Ordinal retrieve the ordinal form of numbers.
    module OrdinalWords
      extend Group
      self.type = :annotator
      self.targets = [:number]
    end
    extend Treat::Category
  end
end

