module Treat
  # Category for processor groups.
  #
  # A processor group is a group of algorithms for the building
  # of trees representing textual entities.
  #
  # The processor groups include:
  #
  #   - Chunkers : split a text into zone objects.
  #   - Segmenters : split a text or zone into sentence objects.
  #   - Tokenizers : split a sentence into Token objects.
  #   - Parsers: split a sentence into a tree of phrases
  #     containing other phrases and Token objects, representing
  #     the syntactic structure.
  module Processors
    # Chunkers split a text into zones.
    module Chunkers
      extend Group
      self.type = :transformer
      self.targets = [:document, :section]
    end
    # Segmenters split a text or zone into sentences.
    module Segmenters
      extend Group
      self.type = :transformer
      self.targets = [:document, :zone]
    end
    # Tokenizers splits a sentence into Token objects.
    module Tokenizers
      extend Group
      self.type = :transformer
      self.targets = [:document, :zone, :phrase]
    end
    # Parsers split a sentence into phrase objects
    # representing its syntactic structure, with the
    # Token objects as children of the phrases.
    module Parsers
      extend Group
      self.type = :transformer
      self.targets = [:document, :zone, :phrase]
    end
    # Makes all the groups autoloadable and creates the workers.
    extend Treat::Category
  end
end
