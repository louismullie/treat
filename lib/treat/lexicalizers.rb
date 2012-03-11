# Lexicalizers allow to retrieve lexical information
# (part of speech tag, general word category, synsets,
# synonyms, antonyms, hyponyms, hypernyms, lexical
# relations, grammatical links).
# of an entity.
module Treat::Lexicalizers

  # Taggers return the part of speech tag of a word.
  module Taggers
    extend Treat::Groupable
    self.type = :annotator
    self.targets = [:sentence, :phrase, :token]
  end

  # Return the general category of a word.
  module Categorizers
    extend Treat::Groupable
    self.type = :annotator
    self.targets = [:token]
    self.default = :from_tag
  end

  # Find the synsets of a word in a lexicon.
  module Sensers
    extend Treat::Groupable
    self.type = :annotator
    self.targets = [:word]
    self.preset_option = :nym
    self.presets = [:synonyms, :antonyms, 
                    :hyponyms, :hypernyms]
  end
  
  # Make Lexicalizers categorizable.
  extend Treat::Categorizable

end