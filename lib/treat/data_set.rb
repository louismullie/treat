class Treat::DataSet

  require 'treat/classification'
  
  attr_reader :classification
  attr_reader :labels
  attr_reader :items
  attr_reader :entities


  def initialize(classification)
    @classification = classification
    @labels = classification.labels
    @items = []
    @entities = []
  end
  
  def <<(entity)
    items << @classification.export_item(entity)
    entities << entity
  end
  
end