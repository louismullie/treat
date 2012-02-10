module Treat
  module Entities
    
    # Require the generic entity lass.
    require 'treat/entities/entity'
    
    # This module groups the mixins for entities.
    module Abilities
      # Require all abilities.
      Dir['treat/entities/abilities/*.rb'].each do |file|
        require file
      end
    end
    
    # Represents a collection of texts.
    class Collection < Entity
      # Initialize the collection with a folder
      # containing the texts of the collection.
      def initialize(folder = nil, id = nil)
        super('', id)
        set :folder, folder
      end
    end
    
    # Represents a document.
    class Document < Entity
      def initialize(file = nil, id = nil)
        super('', id)
        set :file, file
      end
    end
    
    # Represents a zone of text
    # (Title, Paragraph, List, Quote).
    class Zone < Entity; end
    
    # Represents a section, usually with a title
    # and at least one paragraph.
    class Section < Zone; end
    
    # Represents a title, subtitle, logical header.
    class Title < Zone; end
    
    # Represents a paragraph.
    class Paragraph < Zone; end
    
    # Represents a list.
    class List < Zone; end

    # Represents a group of words.
    class Phrase < Entity; end
    
    # Represents a group of words with a sentence ender.
    class Sentence < Phrase; end
    
    # Represents a terminal element in the text structure.
    class Token < Entity; end
    
    # Represents a word.
    class Word < Token
      # A list of all possible word categories.
      Categories = [
        :adjective, :adverb, :noun, :verb, :interjection,
        :clitic, :coverb, :conjunction, :determiner, :particle,
        :preposition, :pronoun, :number, :symbol, :punctuation,
        :complementizer
      ]
    end
    
    # Represents a clitic ('s).
    class Clitic < Token; end
    
    # Represents a number.
    class Number < Token; end
    
    # Represents a punctuation sign.
    class Punctuation < Token; end
    
    # Represents a character that is neither
    # alphabetical, numerical or a punctuation
    # character (e.g. @#$%&*).
    class Symbol < Token; end
    
    # Represents an entity of unknown type.
    class Unknown; end
    
  end
end
