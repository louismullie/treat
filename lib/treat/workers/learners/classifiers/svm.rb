class Treat::Workers::Learners::Classifiers::SVM
  
  require 'svm'
  
  @@classifiers = {}
  
  def self.classify(entity, options = {})
    
    set = options[:training]
    cl = set.problem
    
    if !@@classifiers[cl]
      labels = set.question.labels
      unless labels
        raise Treat::Exception,
        "LibSVM requires that you provide the possible " +
        "labels to assign to classification items when " +
        "specifying the question."
      end
      data = set.items.map { |item| item[:features] }
      prob = Problem.new(labels, data)
      param = Parameter.new(:kernel_type => LINEAR, :C => 10)
      @@classifiers[cl] = Model.new(prob, param)
    end
    
    @@classifiers[cl].predict_probability(
    cl.export_item(entity, false))
    
  end
  
end