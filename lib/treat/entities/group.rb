module Treat::Entities
  
  # Any kind of grouped entities.
  class Group < Treat::Entities::Entity; end

  # Represents a group of words with a sentence ender.
  class Sentence < Group; end

  # Represents a group of words.
  class Phrase < Group; end

  # Represents a non-linguistic fragment
  class Fragment < Group; end

end