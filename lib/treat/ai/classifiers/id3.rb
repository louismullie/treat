class Treat::AI::Classifiers::ID3
  
  require 'decisiontree'
  
  @@classifiers = {}
  
  def self.classify(entity, options = {})
  
    set = options[:training_set]
    cl = set.classification
    
    if !@@classifiers[cl]
      dec_tree = DecisionTree::ID3Tree.new(
      set.labels, set.items, 
      cl.default, :continuous)
      dec_tree.train
    else
      dec_tree = @@classifiers[cl]
    end
    
    dec_tree.predict(
      cl.export_item(entity, false)
    )
    
  end
  
end