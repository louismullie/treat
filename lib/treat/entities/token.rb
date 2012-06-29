module Treat::Entities
  # Represents a terminal element in the text structure.
  class Token < Treat::Entities::Entity; end

  # Represents a word.
  class Word < Token; end

  # Represents a clitic ('s).
  class Enclitic < Token; end

  # Represents a number.
  class Number < Token
    def to_i; to_s.to_i; end
    def to_f; to_s.to_f; end
  end

  # Represents a punctuation sign.
  class Punctuation < Token; end

  # Represents a character that is neither
  # alphabetical, numerical or a punctuation
  # character (e.g. @#$%&*).
  class Symbol < Token; end

  # Represents a url.
  class Url < Token; end

  # Represents a valid RFC822 address.
  class Email < Token; end
  
  # Represents a token whose type
  # cannot be identified.
  class Unknown; end
  
end