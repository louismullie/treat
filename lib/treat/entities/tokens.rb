module Treat
  module Entities
    # Represents a terminal element in the text structure.
    class Token < Entity
      # All tokens are leafs.
      def is_leaf?; true; end
      # Convenience function for statistics.
      def frequency; statistics(:frequency_in); end
      def frequency_in(type); statistics(:frequency_in, type: type); end
      def position_in(type); statistics(:position_in_parent); end
      def tf_idf; statistics(:tf_idf); end
    end
    # Represents a word.
    class Word < Token
      # Convenience function for conjugations.
      def infinitive(conjugator = nil); conjugations(conjugator, :mode => :infinitive); end
      # Convenience function for conjugations.
      def present_participle(conjugator = nil); conjugations(conjugator, :tense => :present, :mode => :participle); end
      # Convenience function for declensions.
      def plural(declensor = nil); declensions(declensor, :count => :plural); end
      # Convenience function for declensions.
      def singular(declensor = nil); declensions(declensor, :count => :singular); end
    end
    # Represents a clitic ('s).
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
