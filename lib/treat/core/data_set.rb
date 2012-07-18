class Treat::Core::DataSet

  attr_accessor :problem
  attr_accessor :items
  attr_accessor :entities
  
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
  
  def <<(entity)
    @items << @problem.
    export_item(entity)
    @entities << entity.id
  end
  
  def serialize(file)
    problem = @problem.dup
    problem.features.each do |feature|
      feature.proc = feature.proc.to_source
    end
    data = [problem, @items, @entities]
    File.open(file, 'w') do |f| 
      f.write(Marshal.dump(data))
    end
  end
  
  def self.unserialize(file)
    data = Marshal.load(File.read(file))
    problem, items, entities = *data
    problem.features.each do |feature|
      source = feature.proc[5..-1]
      feature.proc = eval("Proc.new #{source}")
    end
    data_set = Treat::Core::DataSet.new(problem)
    data_set.items = items
    data_set.entities = entities
    data_set
  end
  
end