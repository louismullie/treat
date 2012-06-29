module Treat::Entities
  # Represents a zone of text
  # (Title, Paragraph, List, Quote).
  class Zone < Treat::Entities::Entity; end

  # Represents a title, subtitle, logical header.
  class Title < Zone; end

  # Represents a paragraph.
  class Paragraph < Zone; end
end