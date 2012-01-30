module Treat
  # Lexicalizers allow the retrieval of lexical information
  # (part of speech tag, synsets, hypersets, hyposets, etc.)
  # of an entity.
  module Lexicalizers
    # Taggers return the part of speech tag of a word.
    module Tag
      extend Group
      require 'treat/lexicalizers/tag/tagger'
      self.type = :annotator
      self.targets = [:sentence, :phrase, :word]
    end
    
    module Category
      extend Group
      self.type = :annotator
      self.targets = [:sentence, :phrase, :word]
    end

    # Linkers allow to retrieve grammatical links
    # between words.
    module Linkages
      extend Group
      self.type = :annotator
      self.targets = [:sentence, :word]
      self.presets = {
        object: {:linkage => :object},
        subject: {:linkage => :subject},
        patient: {:linkage => :patient},
        agent: {:linkage => :agent},
        main_verb: {:linkage => :main_verb}
      }
    end
    
    # Lexicons are dictionnaries of semantically linked
    # word forms.
    module Synsets
      extend Group
      self.type = :annotator
      self.targets = [:word]
      self.decorators = {
        synonyms: lambda do |entity, synsets|
          synsets.collect { |ss| ss.synonyms }.flatten - 
          [entity.value]
        end,
        antonyms: lambda do |entity, synsets|
          synsets.collect { |ss| ss.antonyms }.flatten
        end,
        hyponyms: lambda do |entity, synsets|
          synsets.collect { |e, ss| ss.hyponyms }.flatten
        end,
        hypernyms: lambda do |entity, synsets|
          synsets.collect { |ss| ss.hypernyms }.flatten
        end
      }
    end
    extend Treat::Category
  end
end