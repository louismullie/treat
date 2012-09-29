module Treat::Entities
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
end