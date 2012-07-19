# Defines a question to answer in the
# context of a classification problem.
class Treat::Core::Question
  
  # Defines an arbitrary label for the
  # question we are trying to answer 
  # (e.g. is_key_sentence), which will
  # also be used as the annotation name
  # for the answer to the question.
  attr_accessor :name
  # Can be :continuous or :discrete,
  # depending on the features used.
  attr_accessor :type
  # Defines the target of the question
  # (e.g. :sentence, :paragraph, etc.)
  attr_accessor :target
  # Default for the answer to the question.
  attr_accessor :default
  
  # Initialize the question.
  def initialize(name, target, 
    type = :continuous, default = nil)
    @name, @target = name, target
    @type, @default = type, default
  end

end