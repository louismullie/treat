# Formatters handle conversion of Entities to and from
# external file formats.
module Treat::Formatters
  
  # Readers read a document and create the top-level
  # section(s) corresponding to the content of the document.
  module Readers
    extend Treat::Groupable
    self.type = :transformer
    self.targets = [:document]
    self.default = :autoselect
  end
  
  # Serializers transform entities into a storable format.
  module Serializers
    extend Treat::Groupable
    self.type = :computer
    self.targets = [:entity]
    self.default = :yaml
  end
  
  # Unserializers recreate entities from a serialized format.
  module Unserializers
    extend Treat::Groupable
    self.type = :transformer
    self.targets = [:entity]
    self.default = :autoselect
  end
  
  # Visualizers transform entities into a visualizable format.
  module Visualizers
    extend Treat::Groupable
    self.type = :computer
    self.targets = [:entity]
    self.default = :tree
  end
  
  # Make Formatters categorizable.
  extend Treat::Categorizable
  
end
