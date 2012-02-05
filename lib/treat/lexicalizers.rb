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
      self.targets = [:word]
    end
    
    # Return the general category of a word.
    module Category
      extend Group
      self.type = :annotator
      self.targets = [:word]
      self.default = :from_tag
    end
    
    # Lexicons are dictionnaries of semantically linked
    # word forms.
    module Synsets
      extend Group
      self.type = :annotator
      self.targets = [:word]
      self.postprocessors = {
        :synonyms => lambda do |entity, synsets|
          synsets.collect { |ss| ss.synonyms }.flatten - 
          [entity.value]
        end,
        :antonyms => lambda do |entity, synsets|
          synsets.collect { |ss| ss.antonyms }.flatten
        end,
        :hyponyms => lambda do |entity, synsets|
          synsets.collect { |ss| ss.hyponyms }.flatten
        end,
        :hypernyms => lambda do |entity, synsets|
          synsets.collect { |ss| ss.hypernyms }.flatten
        end
      }
    end
    
    module Linkages
      extend Group
      self.type = :annotator
      self.targets = [:zone]
      self.presets = {
        :is_a => {:linkage => :is_a},
        :synonym_of => {:linkage => :synonym_of},
        :antonym_of => {:linkage => :antonym_of}
      }
    end
    
    extend Treat::Category
  end
end