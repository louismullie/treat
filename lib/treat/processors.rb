# Processors build trees representing textual entities.
module Treat::Processors
  
  # Chunkers split a document or a section into zones.
  module Chunkers
    extend Treat::Groupable
    self.type = :transformer
    self.targets = [:document, :section]
  end
  
  # Segmenters split a document or zone into sentences.
  module Segmenters
    extend Treat::Groupable
    self.type = :transformer
    self.targets = [:document, :zone]
  end
  
  # Tokenizers splits a sentence into Token objects.
  module Tokenizers
    extend Treat::Groupable
    self.type = :transformer
    self.targets = [:document, :zone, :phrase]
  end
  
  # Parsers split a sentence into phrase objects
  # representing its syntactic structure, with the
  # Token objects as children of the phrases.
  module Parsers
    extend Treat::Groupable
    self.type = :transformer
    self.targets = [:phrase]
  end
  
  # Make Processors categorizable.
  extend Treat::Categorizable
  
  def self.warn_if_has_children(entity)
    warn "Warning: can't #{caller_method(2)} an entity that has children."
    warn "Removing all children of text \"#{entity.short_value}].\""
    entity.remove_all!
  end
end