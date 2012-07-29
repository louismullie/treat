# Defines a question to answer in the
# context of a classification problem.
class Treat::Core::Question
  
  require 'treat/core/hashable'
  include Treat::Core::Hashable
  
  # Defines an arbitrary label for the
  # question we are trying to answer 
  # (e.g. is_key_sentence), which will
  # also be used as the annotation name
  # for the answer to the question.
  attr_reader :name
  # Can be :continuous or :discrete,
  # depending on the features used.
  attr_reader :type
  # Defines the target of the question
  # (e.g. :sentence, :paragraph, etc.)
  attr_reader :target
  # Default for the answer to the question.
  attr_reader :default
  
  # Initialize the question.
  def initialize(name, target, 
    type = :continuous, default = nil)
    @name, @target = name, target
    @type, @default = type, default
  end

  # Custom comparison operator for questions.
  def ==(question)
    @name == question.name &&
    @type == question.type &&
    @target == question.target &&
    @default == question.default
  end
  
end