# Processors build trees representing textual entities.
module Treat::Processors
  
  # Chunkers split a document or a section into zones.
  module Chunkers
    extend Treat::Groupable
    self.type = :transformer
    self.targets = [:section]
    self.default = :autoselect
  end
  
  # Segmenters split a document or zone into sentences.
  module Segmenters
    extend Treat::Groupable
    self.type = :transformer
    self.targets = [:zone]
  end
  
  # Tokenizers splits a sentence into Token objects.
  module Tokenizers
    extend Treat::Groupable
    self.type = :transformer
    self.targets = [:zone, :phrase]
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
  
end