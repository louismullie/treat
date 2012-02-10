# Category of worker groups that retrieve
# the inflections of a word.
module Treat::Inflectors

  # Return the stem (*not root form*) of a word.
  module Stem
    extend Treat::Groupable
    self.type = :annotator
    self.targets = [:word]
  end

  # Retrieve the different declensions of a
  # noun (singular, plural).
  module Declensions
    extend Treat::Groupable
    self.type = :annotator
    self.targets = [:word]
    self.presets = {
      :plural => {:count => :plural},
      :singular => {:count => :singular}
    }
  end

  # Retrieve the different conjugations of a word
  # given a mode, tense, person, and/or number.
  module Conjugations
    extend Treat::Groupable
    self.type = :annotator
    self.targets = [:word]
    self.presets = {
      :infinitive => {:mode => :infinitive},
      :present_participle => {
        :tense => :present,
        :mode => :participle
      },
      :plural_verb => {:count => :plural},
      :singular_verb => {:count => :singular}
    }
  end

  # Retrieve the full text description of a
  # cardinal number.
  module CardinalWords
    extend Treat::Groupable
    self.type = :annotator
    self.targets = [:number]
  end

  # Retrieve the full text description of an
  # ordinal number.
  module OrdinalWords
    extend Treat::Groupable
    self.type = :annotator
    self.targets = [:number]
  end

  # Make Inflectors categorizable.
  extend Treat::Categorizable

end