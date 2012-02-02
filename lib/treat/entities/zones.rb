module Treat
  module Entities
    # Represents a zone of text 
    # (Title, Paragraph, List, Quote).
    class Zone < Entity
      def initialize(value = '', id = nil)
        super(value, id)
        @type = :zone
      end
    end
    # Represents a title, subtitle, logical header.
    class Title < Zone
      def initialize(value = '', id = nil)
        super(value, id)
        @type = :title
      end
    end
    # Represents a paragraph.
    class Paragraph < Zone
      def initialize(value = '', id = nil)
        super(value, id)
        @type = :paragraph
      end
    end
    # Represents a list.
    class List < Zone
      def initialize(value = '', id = nil)
        super(value, id)
        @type = :list
      end
    end
    # Represents a section, usually with a title
    # and at least one paragraph.
    class Section < Zone
      def initialize(value = '', id = nil)
        super(value, id)
        @type = :section
      end
    end
  end
end