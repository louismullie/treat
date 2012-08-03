# Represents a feature to be used
# in a classification task.
class Treat::Core::Export
  
  # The name of the feature. If no 
  # proc is supplied, this assumes
  # that the target of your classification
  # problem responds to the method
  # corresponding to this name.
  attr_reader :name
  # The feature's default value, if nil.
  attr_reader :default
  # A proc that can be used to perform
  # calculations before storing a feature.
  attr_accessor :proc
  # The proc as a string value.
  attr_accessor :proc_string
  
  # Initialize a feature for a classification problem.
  def initialize(name, default = nil, proc_string = nil)
    unless name.is_a?(Symbol)
      raise Treat::Exception,
      "The first argument to initialize should "+
      "be a symbol representing the name of the export."
    end
    if proc_string && !proc_string.is_a?(String)
      raise Treat::Exception,
      "The third argument to initialize, " +
      "if supplied, should be a string that " +
      "can be evaluated to yield a Proc."
    end
    @name, @default, @proc_string =
    name, default, proc_string
    begin
      @proc = proc_string ? 
      eval(proc_string) : nil
    rescue Exception => e
      raise Treat::Exception,
      "The third argument to initialize " +
      "did not evaluate without errors " +
      "(#{e.message})."
    end
    if @proc && !@proc.is_a?(Proc)
      raise Treat::Exception,
      "The third argument did not evaluate to a Proc."
    end
  end
  
  # Custom comparison operator for features.
  def ==(feature)
    @name == feature.name &&
    @default == feature.default &&
    @proc_string == feature.proc_string
  end
  
end

class Treat::Core::Feature < Treat::Core::Export; end
class Treat::Core::Tag < Treat::Core::Export; end