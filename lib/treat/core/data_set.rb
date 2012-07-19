# A DataSet contains an entity classification
# problem as well as data for entities that
# have already been classified, complete with
# references to these entities.
class Treat::Core::DataSet

  # Used to serialize Procs.
  silence_warnings do
    require 'sourcify'
  end
  
  # The classification problem this
  # data set holds data for.
  attr_accessor :problem
  # Items that have been already 
  # classified (training data).
  attr_accessor :items
  # References to the IDs of the
  # original entities contained
  # in the data set.
  attr_accessor :entities
  
  # Initialize the DataSet. Can be 
  # done with a Problem entity
  # (thereby creating an empty set)
  # or with a filename (representing
  # a serialized data set which will
  # then be deserialized and loaded).
  def initialize(prob_or_file)
    if prob_or_file.is_a?(String)
      ds = self.class.
      unserialize(prob_or_file)
      @problem = ds.problem
      @items = ds.items
      @entities = ds.entities
    else
      @problem = prob_or_file
      @items, @entities = [], []
    end
  end
  
  # Add an entity to the data set.
  # The entity's relevant features
  # are calculated based on the 
  # classification problem, and a
  # line with the results of the  
  # calculation is added to the 
  # data set, along with the ID
  # of the entity.
  def <<(entity)
    @items << @problem.
    export_item(entity)
    @entities << entity.id
  end
  
  # Marshal the data set to the supplied
  # file name. Marshal is used for speed;
  # other serialization options may be
  # provided in later versions. This 
  # method relies on the sourcify gem
  # to transform Feature procs to strings,
  # since procs/lambdas can't be serialized.
  def serialize(file)
    problem = @problem.dup
    problem.features.each do |feature|
      next unless feature.proc
      feature.proc = feature.proc.to_source
    end
    data = [problem, @items, @entities]
    File.open(file, 'w') do |f| 
      f.write(Marshal.dump(data))
    end
    problem.features.each do |feature|
      next unless feature.proc
      source = feature.proc[5..-1]
      feature.proc = eval("Proc.new #{source}")
    end
  end
  
  # Unserialize a data set file created 
  # by using the #serialize method.
  def self.unserialize(file)
    data = Marshal.load(File.read(file))
    problem, items, entities = *data
    problem.features.each do |feature|
      next unless feature.proc
      source = feature.proc[5..-1]
      feature.proc = eval("Proc.new #{source}")
    end
    data_set = Treat::Core::DataSet.new(problem)
    data_set.items = items
    data_set.entities = entities
    data_set
  end
  
end