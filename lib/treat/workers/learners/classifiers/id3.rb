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
    dset = options[:training]
    prob = dset.problem
    if !@@classifiers[prob]
      dec_tree = DecisionTree::ID3Tree.new(
      prob.feature_labels.map { |l| l.to_s }, 
      dset.items.map { |i| i[:features] }, 
      prob.question.default, prob.question.type)
      dec_tree.train
      @@classifiers[prob] = dec_tree
    else
      dec_tree = @@classifiers[prob]
    end
    vect = prob.export_features(entity, false)
    dec_tree.predict(vect)
  end
  
end