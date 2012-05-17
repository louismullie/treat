# Extractors extract information out of texts.
module Treat::Extractors

  # Extracts the language from an entity.
  module Language
    extend Treat::Groupable
    self.type = :annotator
    self.targets = [:entity]
    self.default = :what_language
  end

  # Extracts the date/time of a phrase.
  module Time
    extend Treat::Groupable
    self.type = :annotator
    self.targets = [:phrase]
  end

  # Extract the topic from a document or zone.
  module Topics
    extend Treat::Groupable
    self.type = :annotator
    self.targets = [:document]
  end

  # Extract the keywords from a text.
  module Keywords
    extend Treat::Groupable
    self.type = :annotator
    self.targets = [:document, :section, :zone]
  end

  # Extract clusters of topic words from a collection.
  module TopicWords
    extend Treat::Groupable
    self.type = :annotator
    self.targets = [:collection]
  end

  # Extract named entities from phrases.
  module NameTag
    extend Treat::Groupable
    self.type = :annotator
    self.targets = [:phrase, :word]
  end

  # Extract coreferences from a zone.
  module Coreferences
    extend Treat::Groupable
    self.type = :annotator
    self.targets = [:zone]
  end
  
  # Retrieve the main grammatical roles
  # in the phrase (subject, verb, object).
  module Roles
    extend Treat::Groupable
    self.type = :annotator
    self.targets = [:phrase]
  end

  module TfIdf
    extend Treat::Groupable
    self.type = :annotator
    self.targets = [:word]
    self.default = :native
  end
  
  module Summary
    extend Treat::Groupable
    self.type = :annotator
    self.targets = [:document]
    self.default = :keyword_count
  end
  
  # Make Extractors categorizable.
  extend Treat::Categorizable
  
end