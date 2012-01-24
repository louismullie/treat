module Treat
  # Formatters handle conversion of Entities to and from
  # external file formats.
  module Formatters
    # Readers read a document and create the top-level entity
    # corresponding to the content of the document.
    module Readers
      extend Group
      self.type = :transformer
      self.targets = [:collection, :document]
      self.default = :autoselect
    end
    # Unserializers recreate entities from a serialized format.
    module Unserializers
      extend Group
      self.type = :transformer
      self.targets = [:collection, :document]
      self.default = :autoselect
    end
    # Visualizers transform entities into a visualizable format.
    module Visualizers
      extend Group
      self.type = :computer
      self.targets = [:entity]
      self.default = :tree
    end
    # Serializers transform entities into a storable format.
    module Serializers
      extend Group
      self.type = :computer
      self.targets = [:entity]
      self.default = :yaml
    end
    # Serializers transform entities into a storable format.
    module Cleaners
      extend Group
      self.type = :annotator
      self.targets = [:document]
      self.default = :html
    end
    extend Treat::Category
  end
end

