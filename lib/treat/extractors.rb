module Treat
  # Extractors extract specific information out of texts.
  module Extractors
    # Extracts a DateTime object containing a timestamp
    # from string representation of date/time.
    module Time
      extend Group
      self.type = :computer
      self.targets = [:word, :constituent, :symbol]
    end
    # Extract the topic from a text.
    module Topics
      extend Group
      self.type = :annotator
      self.targets = [:collection, :document, :text, :zone, :sentence]
    end
    # Extract the topic from a text.
    module TopicWords
      extend Group
      self.type = :annotator
      self.targets = [:collection, :document, :text, :zone, :sentence]
    end
    module Statistics
      extend Group
      self.type = :computer
      self.targets = [:entity]
      self.default = :none
    end
    module NamedEntity
      extend Group
      self.type = :computer
      self.targets = [:entity]
    end
    module KeySentences
      extend Group
      self.type = :computer
      self.targets = [:collection, :document, :text, :zone, :sentence]
    end
    extend Treat::Category
  end
end