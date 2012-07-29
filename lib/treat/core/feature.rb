# Represents a feature to be used
# in a classification task.
class Treat::Core::Feature
  
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
  
  require 'treat/core/hashable'
  include Treat::Core::Hashable
  
  # Initialize a feature for a classification problem.
  def initialize(name, default = nil, proc_string = nil)
    @name, @default, @proc_string =
    name, default, proc_string
    @proc = proc_string ? eval(proc_string) : nil
  end
  
  # Custom comparison operator for features.
  def ==(feature)
    @name == feature.name &&
    @proc == feature.proc &&
    @default == feature.default
  end
  
end