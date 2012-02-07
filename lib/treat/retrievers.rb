module Treat
  module Retrievers
    module Indexers
      extend Group
      self.type = :annotator
      self.targets = [:collection]
      self.default = :ferret
    end
    module Searchers
      extend Group
      self.type = :annotator
      self.targets = [:entity]
      self.default = :ferret
    end
    extend Treat::Category
  end
end