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
    self.targets = [:word]
    self.default = :from_tag
  end

  # Find the synsets of a word in a lexicon.
  module Synsets
    extend Treat::Groupable
    self.type = :annotator
    self.targets = [:word]
    self.presets = {
      :synonyms => {:nym => :synonym},
      :antonyms => {:nym => :antonym},
      :hyponyms => {:nym => :hyponym},
      :hypernyms => {:nym => :hypernym}
    }
  end

  # Find the lexical relations between words.
  module Relations
    extend Treat::Groupable
    self.type = :annotator
    self.targets = [:zone]
    self.presets = {
      :is_a => {:relation => :is_a},
      :synonym_of => {:relation => :synonym_of},
      :antonym_of => {:relation => :antonym_of}
    }
  end

  # Find the grammatical links between words.
  module Linkages
    extend Treat::Groupable
    self.type = :annotator
    self.targets = [:zone]
    self.presets = {
      :main_verb => {:relation => :main_verb},
      :object => {:relation => :object},
      :subject => {:relation => :subject}
    }
  end

  # Make Lexicalizers categorizable.
  extend Treat::Categorizable

end
