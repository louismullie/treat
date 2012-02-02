module Treat
  module Entities
    # Represents any syntactic phrase of a sentence.
    class Phrase < Entity
      def initialize(value = '', id = nil)
        super(value, id)
        @type = :phrase
      end
    end
    class Sentence < Phrase
      def initialize(value = '', id = nil)
        super(value, id)
        @type = :sentence
      end
    end
  end
end
