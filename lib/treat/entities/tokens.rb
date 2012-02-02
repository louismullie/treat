module Treat
  module Entities
    # Represents a terminal element in the text structure.
    class Token < Entity
      # All tokens are leafs.
      def is_leaf?; true; end
      def initialize(value = '', id = nil)
        super(value, id)
        @type = :token
      end
    end
    # Represents a word.
    class Word < Token
      def initialize(value = '', id = nil)
        super(value, id)
        @type = :word
      end
    end
    # Represents a clitic ('s).
    class Clitic < Token
      def initialize(value = '', id = nil)
        super(value, id)
        @type = :clitic
      end
    end
    # Represents a number.
    class Number < Token
      # Convert the number to an integer.
      def to_i; to_s.to_i; end
      # Convert the number to a float.
      def to_f; to_s.to_f; end
      def initialize(value = '', id = nil)
        super(value, id)
        @type = :number
      end
    end
    # Represents a punctuation sign.
    class Punctuation < Token
      def initialize(value = '', id = nil)
        super(value, id)
        @type = :punctuation
      end
    end
    # Represents a character that is neither
    # alphabetical, numerical or a punctuation
    # character (e.g. @#$%&*).
    class Symbol < Token
      def initialize(value = '', id = nil)
        super(value, id)
        @type = :symbol
      end
    end
    # Represents an entity of unknown type.
    class Unknown < Token
      def initialize(value = '', id = nil)
        super(value, id)
        @type = :unknown
      end
    end
  end
end
