# A DataSet contains an entity classification
# problem as well as data for entities that
# have already been classified, complete with
# references to these entities.
class Treat::Core::DataSet
  
  # The classification problem this
  # data set holds data for.
  attr_accessor :problem
  # Items that have been already 
  # classified (training data).
  attr_accessor :items
  
  # Initialize the DataSet.
  def initialize(problem)
    unless problem.is_a?(Treat::Core::Problem)
      raise Treat::Exception, "The first argument " +
      "to initialize should be an instance of " +
      "Treat::Core::Problem."
    end
    @problem, @items = problem, []
  end
  
  def self.build(from)
    if from.is_a?(Hash)
      Treat::Core::DataSet.unserialize(
      Treat.databases.default.adapter, from)
    elsif from.is_a?(String)
      unless File.readable?(from)
        raise Treat::Exception,
        "Attempting to initialize data set from " +
        "file '#{from}', but it is not readable."
      end
      Treat::Core::DataSet.unserialize(
      File.extname(from)[1..-1], file: from)
    end
  end
  
  # Add an entity to the data set. The 
  # entity's relevant features are 
  # calculated based on the classification 
  # problem, and a line with the results 
  # of the calculation is added to the 
  # data set, along with the ID of the entity.
  def <<(entity)
    @items << { 
    tags: (!@problem.tags.empty? ? 
    @problem.export_tags(entity) : []),
    features: @problem.
    export_features(entity),
    id: entity.id }
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
    problem.tags.each do |tag|
      tag.proc = nil
    end
    data = [problem, @items]
    File.open(file, 'w') do |f| 
      f.write(Marshal.dump(data))
    end
  end
  
  # Unserialize the data using Marshal.
  def self.from_marshal(options)
    file = options[:file]
    data = Marshal.load(File.binread(file))
    problem, items = *data
    problem.features.each do |feature|
      next unless feature.proc_string
      feature.proc = eval(feature.proc_string)
    end
    problem.tags.each do |tag|
      next unless tag.proc_string
      tag.proc = eval(tag.proc_string)
    end
    data_set = Treat::Core::DataSet.new(problem)
    data_set.items = items
    data_set
  end
  
  # Serialize the data set to a MongoDB record.
  def to_mongo(options)
    require 'mongo'
    host = options[:host] || Treat.databases.mongo.host
    db = options[:db] || Treat.databases.mongo.db
    # UNLESS HOST, UNLESS DB
    database = Mongo::Connection.new(host).db(db)
    database.collection('problems').update(
    {id: @problem.id}, @problem.to_hash, {upsert: true})
    feature_labels = @problem.feature_labels
    feature_labels << @problem.question.name
    tag_labels = @problem.tag_labels
    tags = @problem.tags.map  { |t| t.name }
    data = database.collection('data')
    pid = @problem.id
    @items.each do |item|
      item[:features] = Hash[feature_labels.zip(item[:features])]
      item[:tags] = Hash[tag_labels.zip(item[:tags])]
      item[:problem] = pid
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
    items = []
    data.each do |datum|
      datum.delete("_id"); datum.delete('problem')
      item = {}
      item[:features] = datum['features'].values
      item[:tags] = datum['tags'].values
      item[:id] = datum['id']
      items << item
    end
    data_set = Treat::Core::DataSet.new(problem)
    data_set.items = items
    data_set
  end

  # Merge another data set into this one.
  def merge(data_set)
    if data_set.problem != @problem
      raise Treat::Exception,
      "Cannot merge two data sets that " +
      "don't reference the same problem." 
    else
      @items += data_set.items
    end
  end
  
  # Compare with other data set.
  def ==(data_set)
    @problem == data_set.problem &&
    @items == data_set.items
  end
  
end