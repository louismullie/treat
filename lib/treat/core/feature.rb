# Represents a feature to be used
# in a classification task.
class Treat::Core::Feature

  # The name of the feature. If no 
  # proc is supplied, this assumes
  # that the target of your classification
  # problem responds to the method
  # corresponding to this name.
  attr_reader :name
  # A proc that can be used to perform
  # calculations before storing a feature.
  attr_accessor :proc
  # The default value to be
  attr_reader :default
  
  # Initialize a feature for a classification
  # problem. If two arguments are supplied, 
  # the second argument is assumed to be the
  # default value. If three arguments are 
  # supplied, the second argument is the
  # callback to generate the feature, and 
  # the third one is the default value.
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
  
  # Custom comparison operator for features.
  def ==(feature)
    @name == feature.name &&
    @proc == feature.proc &&
    @default == feature.default
  end
  
end