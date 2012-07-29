# Defines a classification problem.
# - What question are we trying to answer?
# - What features are we going to look at
#   to attempt to answer that question?
class Treat::Core::Problem

  # The question we are trying to answer.
  attr_reader :question
  # An array of features that will be 
  # looked at in trying to answer the
  # problem's question.
  attr_reader :features
  # Just the labels from the features.
  attr_reader :labels
  # A unique identifier for the problem.
  attr_accessor :id
  
  # Initialize the problem with a question
  # and an arbitrary number of features.
  def initialize(question, *features)
    unless question.is_a?(Treat::Core::Question)
      raise Treat::Exception,
      "The first argument to initialize should be " +
      "an instance of Treat::Core::Question."
    end
    if features.any? { |f| !f.is_a?(Treat::Core::Feature) }
      raise Treat::Exception,
      "The second argument and all subsequent ones " +
      "to initialize should be instances of Treat::" +
      "Core::Feature."
    end
    @question = question
    @features = features
    @labels = @features.map { |f| f.name }
    @id = object_id
  end
  
  # Custom comparison for problems.
  def ==(problem)
    @question == problem.question &&
    @features == problem.features
  end

  # Return an array of all the entity's
  # features, as defined by the problem.
  # If include_answer is set to true, will
  # append the answer to the problem after
  # all of the features.
  def export_item(e, what = :features, include_answer = true)
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
  
  def to_hash
    {'question' => @question.to_hash,
    'features' => @features.map { |f| 
    f.tap { |f| f.proc = nil }.to_hash },
    'id' => @id }
  end
  
  def self.from_hash(hash)
    question = Treat::Core::Question.new(
      hash['question']['name'], 
      hash['question']['target'],
      hash['question']['type'],
      hash['question']['default']
    )
    features = []
    hash['features'].each do |feature|
      features << Treat::Core::Feature.new(
      feature['name'], feature['default'],
      feature['proc_string'])
    end
    p = Treat::Core::Problem.new(question, *features)
    p.id = hash['id']
    p
  end

end