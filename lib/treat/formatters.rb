# Formatters handle conversion of Entities to and from
# external file formats.
module Treat::Formatters
  
  # Readers read a document's content.
  module Readers
    extend Treat::Groupable
    self.type = :computer
    self.targets = [:document]
  end
  
  # Unserializers recreate entities 
  # from a serialized format.
  module Unserializers
    extend Treat::Groupable
    self.type = :computer
    self.targets = [:entity]
  end
  
  # Serializers transform entities 
  # into a storable format.
  module Serializers
    extend Treat::Groupable
    self.type = :computer
    self.targets = [:entity]
    self.default = :yaml
  end
  
  # Visualizers transform entities 
  # into a visualizable format.
  module Visualizers
    extend Treat::Groupable
    self.type = :computer
    self.targets = [:entity]
    self.default = :tree
  end
  
  # Make Formatters categorizable.
  extend Treat::Categorizable
  
end
