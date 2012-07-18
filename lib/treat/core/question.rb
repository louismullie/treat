class Treat::Core::Question
  
  attr_accessor :name
  attr_accessor :type
  attr_accessor :default
  
  def initialize(name, target, 
    type = :continuous, default = nil)
    @name, @target = name, target
    @type, @default = type, default
  end

end