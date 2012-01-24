module Treat
  module Entities
    # Represents any syntactic constituent
    # of a sentence.
    class Constituent < Entity
    end
    # Represents a phrase inside a sentence
    # or by itself.
    class Phrase < Constituent
    end
    # Represents a clause inside a sentence.
    class Clause < Constituent
    end
  end
end
