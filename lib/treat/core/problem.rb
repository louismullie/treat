# Defines a classification problem.
# - What question are we trying to answer?
# - What features are we going to look at
#   to attempt to answer that question?
class Treat::Core::Problem

  # A unique identifier for the problem.
  attr_accessor :id
  # The question we are trying to answer.
  attr_reader :question
  # An array of features that will be 
  # looked at in trying to answer the
  # problem's question.
  attr_reader :features
  attr_reader :tags
  # Just the labels from the features.
  attr_reader :feature_labels
  attr_reader :tag_labels
  
  # Initialize the problem with a question
  # and an arbitrary number of features.        # FIXME: init with id!?
  def initialize(question, *exports)
    unless question.is_a?(Treat::Core::Question)
      raise Treat::Exception,
      "The first argument to initialize " +
      "should be an instance of " +
      "Treat::Core::Question."
    end
    if exports.any? { |f| !f.is_a?(Treat::Core::Export) }
      raise Treat::Exception,
      "The second argument and all subsequent ones " +
      "to initialize should be instances of subclasses " +
      "of Treat::Core::Export."
    end
    @question, @id = question, object_id
    @features = exports.select do |exp|
      exp.is_a?(Treat::Core::Feature)
    end
    if @features.size == 0
      raise Treat::Exception, 
      "Problem should be supplied with at least "+
      "one feature to work with."
    end
    @tags = exports.select do |exp|
      exp.is_a?(Treat::Core::Tag)
    end
    @feature_labels = @features.map { |f| f.name }
    @tag_labels = @tags.map { |t| t.name }
  end
  
  # Custom comparison for problems.
  # Should we check for ID here ? FIXME
  def ==(problem)
    @question == problem.question &&
    @features == problem.features &&
    @tags == problem.tags
  end

  # Return an array of all the entity's
  # features, as defined by the problem.
  # If include_answer is set to true, will
  # append the answer to the problem after
  # all of the features.
  def export_features(e, include_answer = true)
    features = export(e, @features)
    return features unless include_answer
    features << (e.has?(@question.name) ? 
    e.get(@question.name) : @question.default)
    features
  end
  
  def export_tags(entity)
    if @tags.empty?
      raise Treat::Exception,
      "Cannot export the tags, because " +
      "this problem doesn't have any."
    end
    export(entity, @tags)
  end

  def export(entity, exports)
    unless @question.target == entity.type
      raise Treat::Exception, 
      "This classification problem targets #{@question.target}s, " +
      "but a(n) #{entity.type} was passed to export instead."
    end
    ret = []
    exports.each do |export|
      r = export.proc ? 
      export.proc.call(entity) : 
      entity.send(export.name)
      ret << (r || export.default)
    end
    ret
  end
  
  def to_hash
    {'question' => @question.to_hash,
    'features' => @features.map { |f| 
    f.tap { |f| f.proc = nil }.to_hash },
    'tags' => @tags.map { |t| 
    t.tap { |t| t.proc = nil }.to_hash },
    'id' => @id }
  end
  
  def self.from_hash(hash)
    question = Treat::Core::Question.new(
      hash['question']['name'], 
      hash['question']['target'],
      hash['question']['type'],
      hash['question']['default'],
      hash['question']['labels']
    )
    features = []
    hash['features'].each do |feature|
      features << Treat::Core::Feature.new(
      feature['name'], feature['default'],
      feature['proc_string'])
    end
    tags = []
    hash['tags'].each do |tag|
      tags << Treat::Core::Tag.new(
      tag['name'], tag['default'],
      tag['proc_string'])
    end
    features_and_tags = features + tags
    p = Treat::Core::Problem.new(question, *features_and_tags)
    p.id = hash['id']
    p
  end

end