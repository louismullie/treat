module Treat::Entities
  # Represents a section.
  class Section < Entity; end

  # Represents a page of text.
  class Page < Section; end

  # Represents a block of text 
  class Block < Section; end

  # Represents a list.
  class List < Section; end
end