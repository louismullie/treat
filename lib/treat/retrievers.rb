# Retrievers find documents in collections.
module Treat::Retrievers
  
  # Indexers create an index of words used
  # in the documents within a collection.
  module Indexers
    extend Treat::Groupable
    self.type = :annotator
    self.targets = [:collection]
    self.default = :ferret
  end
  
  # Searchers perform full-text search
  # on indexed collections in order
  # to retrieve documents matching
  # a query.
  module Searchers
    extend Treat::Groupable
    self.type = :computer
    self.targets = [:collection]
    self.default = :ferret
  end
  
  # Make Retrievers categorizable.
  extend Treat::Categorizable
  
end
