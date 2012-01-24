module Treat
  # Lexicalizers allow the retrieval of lexical information
  # (part of speech tag, synsets, hypersets, hyposets, etc.)
  # of an entity.
  module Lexicalizers
    # Taggers return the part of speech tag of a word.
    module Tag
      extend Group
      self.type = :annotator
      self.targets = [:phrase, :word]
    end
    module Category
      extend Group
      self.type = :annotator
      self.targets = [:phrase, :word]
      
      def self.cat(entity, category); category; end # Remove
    end
    # Linkers allow to retrieve grammatical links
    # between words.
    module Linkages
      extend Group
      self.type = :annotator
      self.targets = [:sentence, :word]
    end
    # Lexicons are dictionnaries of semantically linked
    # word forms.
    module Synsets
      extend Group
      self.type = :annotator
      self.targets = [:word, :number]
      
      def self.synonyms(entity, synsets)
        synsets.collect { |ss| ss.synonyms }.flatten - [entity.value]
      end
      def self.antonyms(entity, synsets)
        synsets.collect { |ss| ss.antonyms }.flatten
      end    
      def self.hyponyms(entity, synsets)
        synsets.collect { |ss| ss.hyponyms }.flatten
      end
      def self.hypernyms(entity, synsets)
        synsets.collect { |ss| ss.hypernyms }.flatten
      end
      
    end
    extend Treat::Category
  end
end