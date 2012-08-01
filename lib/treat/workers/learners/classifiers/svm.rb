class Treat::Workers::Learners::Classifiers::SVM
  
  require 'svm'
  
  @@classifiers = {}
  
  def self.classify(entity, options = {})
    
    set = options[:training]
    problem = set.problem
    
    if !@@classifiers[problem]
      labels = problem.question.labels
      unless labels
        raise Treat::Exception,
        "LibSVM requires that you provide the possible " +
        "labels to assign to classification items when " +
        "specifying the question."
      end
      data = set.items.map  { |item| item[:features] }
      prob = Problem.new(labels, data)
      param = Parameter.new(:kernel_type => LINEAR, :C => 10)
      @@classifiers[problem] = Model.new(prob, param)
    end

    @@classifiers[problem].predict_probability(
    problem.export_features(entity, false))[0]
    
  end
  
end