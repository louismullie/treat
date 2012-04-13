module Treat::AI
  
  module Classifiers
    extend Treat::Groupable
    self.type = :computer
    self.targets = [:entity]
    self.default = :id3
  end
  
  extend Treat::Categorizable
  
end