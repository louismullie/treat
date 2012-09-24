# Classification based on Ross Quinlan's ID3 
# (Iterative Dichotomiser 3) decision tree 
# algorithm.
# 
# Original paper: Quinlan, J. R. 1986. 
# Induction of Decision Trees. Mach. Learn. 
# 1, 1 (Mar. 1986), 81-106.
class Treat::Workers::Learners::Classifiers::ID3
  
  require 'decisiontree'
  
  @@classifiers = {}
  
  def self.classify(entity, options = {})
    
    set = options[:training]
    cl = set.problem
    
    if !@@classifiers[cl]
      dec_tree = DecisionTree::ID3Tree.new(
      cl.feature_labels.map { |l| l.to_s }, 
      set.items.map { |i| i[:features]}, 
      cl.question.default, cl.question.type)
      dec_tree.train
      @@classifiers[cl] = dec_tree
    else
      dec_tree = @@classifiers[cl]
      dec_tree.graph('testingbitch')
    end
    dec_tree.predict(
      cl.export_features(entity, false)
    )
  end
  
end