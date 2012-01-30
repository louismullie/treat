module Treat
  # Extractors extract specific information out of texts.
  module Extractors
    # Extracts the time of an object and annotates it
    # with specific information regarding time.
    module Time
      extend Group
      self.type = :annotator
      self.targets = [:phrase]
    end
    # Extract the topic from a text.
    module Topics
      extend Group
      self.type = :annotator
      self.targets = [:collection, :document]
    end
    # Extract the topic from a text.
    module TopicWords
      extend Group
      self.type = :annotator
      self.targets = [:collection, :document]
    end
    # Extract the key sentences from a text.
    module Keywords
      extend Group
      self.type = :annotator
      self.targets = [:collection, :document]
    end
    # Extract named entities from texts.
    module NamedEntity
      extend Group
      self.type = :computer
      self.targets = [:sentence]
    end
    # This module should be moved out of here ASAP.
    module Statistics
      extend Group
      self.type = :annotator
      self.targets = [:entity]
      self.default = :none
    end
    extend Treat::Category
  end
end