# Defines a classification problem.
# - What question are we trying to answer?
# - What features are we going to look at
#   to attempt to answer that question?
class Treat::Core::Problem

  # The question we are trying to answer.
  attr_accessor :question
  # An array of features that will be 
  # looked at in trying to answer the
  # problem's question.
  attr_accessor :features
  # Just the labels from the features.
  attr_accessor :labels
  
  # Initialize the problem with a question
  # and an arbitrary number of features.
  def initialize(question, *features)
    @question = question
    @features = features
    @labels = @features.map { |f| f.name }
  end

  # Return an array of all the entity's
  # features, as defined by the problem.
  # If include_answer is set to true, will
  # append the answer to the problem after
  # all of the features.
  def export_item(e, include_answer = true)
    line = []
    @features.each do |feature|
      r = feature.proc ? 
      feature.proc.call(e) : 
      e.send(feature.name)
      line << (r || feature.default)
    end
    return line unless include_answer
    line << (e.has?(@question.name) ? 
    e.get(@question.name) : @question.default)
    line
  end

end