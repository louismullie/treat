# Lexicalizers allow to retrieve lexical information
# (part of speech tag, general word category, synsets,
# synonyms, antonyms, hyponyms, hypernyms, lexical
# relations, grammatical links).
# of an entity.
module Treat::Lexicalizers

  # Taggers return the part of speech tag of a word.
  module Tag
    extend Treat::Groupable
    self.type = :annotator
    self.targets = [:sentence, :phrase, :token]
  end

  # Return the general category of a word.
  module Category
    extend Treat::Groupable
    self.type = :annotator
    self.targets = [:token]
    self.default = :from_tag
  end

  # Find the synsets of a word in a lexicon.
  module Synsets
    extend Treat::Groupable
    self.type = :annotator
    self.targets = [:word]
    self.preset_option = :nym
    self.presets = [:synonyms, :antonyms, 
                    :hyponyms, :hypernyms]
  end

  # Find the lexical relations between words.
  module Relations
    extend Treat::Groupable
    self.type = :annotator
    self.targets = [:document, :zone, :sentence, :phrase]
    self.preset_option = :relation
    self.presets = [:hyponym_of, :hypernym_of, 
                    :synonym_of, :antonym_of]
  end

  # Find the grammatical links between words.
  module Linkages
    extend Treat::Groupable
    self.type = :annotator
    self.targets = [:phrase]
    self.preset_option = :linkage
    self.presets = [:subject, :main_verb, :object]
  end

  # Make Lexicalizers categorizable.
  extend Treat::Categorizable

end
