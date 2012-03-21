module Treat::Entities

  # Require the generic entity lass.
  require 'treat/entities/entity'

  # Represents a collection of texts.
  class Collection < Entity
    
    # Initialize the collection with a folder
    # containing the texts of the collection.
    def initialize(folder = nil, id = nil)
      super('', id)
      set :folder, folder
      i = folder + '/.index'
      set :index, i if FileTest.directory?(i)
    end

    # Works like the default <<, but if the
    # file being added is a collection or a
    # document, then copy that collection or
    # document into this collection's folder.
    def <<(entities, copy = true)
      unless entities.is_a? Array
        entities = [entities]
      end
      entities.each do |entity|
        if [:document, :collection].
          include?(entity.type) && copy
          entity = entity.copy_into(self)
        end
      end
      super(entities)
    end

  end

  # Represents a document.
  class Document < Entity
    
    def initialize(file = nil, id = nil)
      super('', id)
      set :file, file
    end

  end

  # Represents a section, usually with a title
  # and at least one paragraph.
  class Section < Entity; end

  # Represents a zone of text
  # (Title, Paragraph, List, Quote).
  class Zone < Entity; end

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
  class Token < Entity
  end

  # Represents a word.
  class Word < Token
  end

  # Represents a clitic ('s).
  class Clitic < Token; end

  # Represents a number.
  class Number < Token
    def to_i; to_s.to_i; end
    def to_f; to_s.to_f; end
  end

  # Represents a punctuation sign.
  class Punctuation < Token; end

  # Represents a character that is neither
  # alphabetical, numerical or a punctuation
  # character (e.g. @#$%&*).
  class Symbol < Token; end

  # Represents a url.
  class Url < Token; end

  # Represents a valid RFC822 address.
  class Email < Token; end

  # Represents an entity of unknown type.
  class Unknown; end

end
