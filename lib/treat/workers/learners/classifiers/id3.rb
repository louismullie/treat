class Treat::Workers::Learners::Classifiers::ID3
  
  require 'decisiontree'
  
  @@classifiers = {}
  
  def self.classify(entity, options = {})
    
    set = options[:training]
    cl = set.problem
    
    if !@@classifiers[cl]
      dec_tree = DecisionTree::ID3Tree.new(
      cl.labels.map { |l| l.to_s }, set.items, cl.question.default, 
      cl.question.type)
      dec_tree.train
      @@classifiers[cl] = dec_tree
    else
      dec_tree = @@classifiers[cl]
      dec_tree.graph('testingbitch')
    end
    dec_tree.predict(
      cl.export_item(entity, false)
    )
  end
  
end