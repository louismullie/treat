module Treat
  module Entities
    # Represents a zone of text 
    # (Title, Paragraph, List, Quote).
    class Zone < Entity
    end
    # Represents a title, subtitle, logical header.
    class Title < Zone
    end
    # Represents a paragraph.
    class Paragraph < Zone
    end
    # Represents a list.
    class List < Zone
    end
  end
end