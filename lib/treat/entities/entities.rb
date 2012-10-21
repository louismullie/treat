module Treat::Entities
  
  # * Collection and document classes * #
  
  # Represents a collection.
  class Collection < Entity; end
  # Represents a document.
  class Document < Entity; end
    
  # * Sections and related classes * #
  
  # Represents a section.
  class Section < Entity; end

  # Represents a page of text.
  class Page < Section; end

  # Represents a block of text 
  class Block < Section; end
  
  # * Zones and related classes * #
  
  # Represents a zone of text.
  class Zone < Entity; end

  # Represents a title, subtitle, 
  # logical header of a text.
  class Title < Zone; end

  # Represents a paragraph (group 
  # of sentences and/or phrases).
  class Paragraph < Zone; end
  
  # Represents a list.
  class List < Zone; end
  
  # * Groups and related classes * #
  
  # Represents a group of tokens.
  class Group < Entity; end

  # Represents a group of words 
  # with a sentence ender (.!?)
  class Sentence < Group; end

  # Represents a group of words,
  # with no sentence ender.
  class Phrase < Group; end

  # Represents a non-linguistic
  # fragment (e.g. stray symbols).
  class Fragment < Group; end
  
  # * Tokens and related classes* #
  
  # Represents a terminal element 
  # (leaf) in the text structure.
  class Token < Entity; end

  # Represents a word.  Strictly,
  # this is /^[[:alpha:]\-']+$/.
  class Word < Token; end

  # Represents an enclitic.
  # Strictly, this is any of 
  # 'll 'm 're 's 't or 've.
  class Enclitic < Token; end

  # Represents a number. Strictly,
  # this is /^#?([0-9]+)(\.[0-9]+)?$/.
  class Number < Token
    def to_i; to_s.to_i; end
    def to_f; to_s.to_f; end
  end

  # Represents a punctuation sign.
  # Strictly, this is /^[[:punct:]\$]+$/.
  class Punctuation < Token; end

  # Represents a character that is neither
  # a word, an enclitic, a number or a
  # punctuation character (e.g. @#$%&*).
  class Symbol < Token; end

  # Represents a url. This is (imperfectly)
  # defined as /^(http|https):\/\/[a-z0-9] 
  # +([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}
  # (([0-9]{1,5})?\/.*)?$/ix
  class Url < Token; end

  # Represents a valid RFC822 address.
  # This is (imperfectly) defined as 
  # /.+\@.+\..+/ (fixme maybe?)
  class Email < Token; end
  
  # Represents a token whose type
  # cannot be identified.
  class Unknown; end
  
end