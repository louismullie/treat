module Treat
  module Entities
    # Represents a terminal element in the text structure.
    class Token < Entity
      # All tokens are leafs.
      def is_leaf?; true; end
      def frequency; self.set :frequency, statistics(:frequency); end
    end
    # Represents a word.
    class Word < Token
      def infinitive(conjugator = nil); conjugate(conjugator, :mode => :infinitive); end
      def present_participle(conjugator = nil); conjugate(conjugator, :tense => :present, :mode => :participle); end
      def plural(declensor = nil); declense(declensor, :count => :plural); end
      def singular(declensor = nil); declense(declensor, :count => :singular); end
    end
    class Clitic < Token
    end
    # Represents a number.
    class Number < Token
      # Convert the number to an integer.
      def to_i; to_s.to_i; end
      # Convert the number to a float.
      def to_f; to_s.to_f; end
    end
    # Represents a punctuation sign.
    class Punctuation < Token
    end
    # Represents a character that is neither
    # alphabetical, numerical or a punctuation
    # character (e.g. @#$%&*).
    class Symbol < Token
    end
    # Represents an entity of unknown type.
    class Unknown < Token
    end
  end
end
