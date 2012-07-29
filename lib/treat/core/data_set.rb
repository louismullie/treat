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
  def initialize(prob_or_file, options = {})
    if prob_or_file.is_a?(Symbol)       # FIX THIS
      ds = self.class.
      unserialize(prob_or_file, options)
      @problem = ds.problem
      @items = ds.items
      @entities = ds.entities
    else
      @problem = prob_or_file
      @items, @entities = [], []
    end
  end
  
  # Add an entity to the data set. The 
  # entity's relevant features are 
  # calculated based on the classification 
  # problem, and a line with the results 
  # of the calculation is added to the 
  # data set, along with the ID of the entity.
  def <<(entity)
    @items << @problem.export_item(entity)
    @entities << entity.id
  end
  
  # Serialize the data set to a file,
  # or store it inside the database.
  def serialize(handler, options = {})
    send("to_#{handler}", options)
  end
  
  # Unserialize a data set file created 
  # by using the #serialize method.
  def self.unserialize(handler, options)
    self.send("from_#{handler}", options)
  end
  
  # Serialize the data set using Marshal.
  def to_marshal(options)
    file = options[:file]
    problem = @problem.dup
    problem.features.each do |feature|
      feature.proc = nil
    end
    data = [problem, @items, @entities]
    File.open(file, 'w') do |f| 
      f.write(Marshal.dump(data))
    end
  end
  
  # Unserialize the data using Marshal.
  def self.from_marshal(options)
    file = options[:file]
    data = Marshal.load(File.binread(file))
    problem, items, entities = *data
    problem.features.each do |feature|
      next unless feature.proc_string
      feature.proc = eval(feature.proc_string)
    end
    data_set = Treat::Core::DataSet.new(problem)
    data_set.items = items
    data_set.entities = entities
    data_set
  end
  
  # Serialize the data set to a MongoDB record.
  def to_mongo(options)
    require 'mongo'
    host = options[:host] || Treat.databases.mongo.host
    db = options[:db] || Treat.databases.mongo.db
    database = Mongo::Connection.new(host).db(db)
    database.collection('problems').update(
    {id: @problem.id}, @problem.to_hash, {upsert: true})
    features = @problem.features.map { |f| f.name }
    features << @problem.question.name
    data = database.collection('data')
    pid = @problem.id
    @items.zip(@entities).each do |item, id|
      item = Hash[features.zip(item)]
      item[:entity], item[:problem] = id, pid
      data.insert(item)
    end
  end
  
  def self.from_mongo(options)
    require 'mongo'
    host = options.delete(:host) || Treat.databases.mongo.host
    db = options.delete(:db) || Treat.databases.mongo.db
    database = Mongo::Connection.new(host).db(db)
    p_record = database.collection('problems').
    find_one(id: options[:problem])
    unless p_record
      raise Treat::Exception, 
      "Couldn't retrieve problem ID #{options[:problem]}."
    end
    problem = Treat::Core::Problem.from_hash(p_record)
    data = database.collection('data').find(options).to_a
    items, entities = [], []
    data.each do |datum|
      datum.delete("_id"); datum.delete('problem')
      entities << datum.delete('entity')
      items << datum.values
    end
    data_set = Treat::Core::DataSet.new(problem)
    data_set.items = items
    data_set.entities = entities
    data_set
  end

  # Merge another data set into this one.
  def merge(data_set)
    if data_set.problem != @problem
      raise Treat::Exception,
      "Cannot merge two data sets that " +
      "don't reference the same problem." 
    else
      @items << data_set.items
      @entities << data_set.entities
    end
  end
  
end