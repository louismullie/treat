class Treat::Core::DataSet
  
  attr_reader :classification
  attr_reader :labels
  attr_reader :items
  attr_reader :ids
  
  def self.open(file)
    unless File.readable?(file)
      raise Treat::Exception,
      "Cannot load data set "+
      "from #{file} because " +
      "it doesn't exist."
    end
    ::Psych.load(
    File.read(file))
  end
  
  def initialize(classification)
    @classification = classification
    @labels = classification.labels
    @items = []
    @ids = []
  end
  
  def <<(entity)
    @items << 
    @classification.
    export_item(entity)
    @ids << entity.id
  end
  
  def save(file)
    File.open(file, 'w') do |f|
      f.write(::Psych.dump(self))
    end
  end
  
  def to_ai4r
    Ai4r::Data::DataSet.new(
      :data_items => items, 
      :data_labels => (
        labels.map { |l| l.to_s } + 
        [classification.question.to_s]
    ))
  end
  
end