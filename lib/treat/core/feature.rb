class Treat::Core::Feature
  
  silence_warnings do
    require 'sourcify'
  end
  
  attr_accessor :name, :proc, :default
  
  def initialize(name, proc_or_default = nil, default = nil)
    @name = name
    if proc_or_default.is_a?(Proc)
      @proc, @default = 
      proc_or_default, default
    else
      @proc = nil
      @default = proc_or_default
    end
  end
  
end