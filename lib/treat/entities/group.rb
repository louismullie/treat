module Treat::Entities
  
  # Represents a group of tokens.
  class Group < Entity; end

  # Represents a group of words 
  # with a sentence ender (.!?)
  class Sentence < Group; end

  # Represents a group of words,
  # with no sentence ender.
  class Phrase < Group; end

  # Represents a non-linguistic
  # fragment (e.g. stray symbols).
  class Fragment < Group; end

end