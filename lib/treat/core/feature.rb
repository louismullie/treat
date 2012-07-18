class Treat::Core::Feature
  
  silence_warnings do
    require 'sourcify'
  end
  
  attr_accessor :name, :proc, :default
  
  def initialize(name, proc = nil, default = nil)
    @name, @proc, @default = name, proc, default
  end
  
end