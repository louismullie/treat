class Treat::Workers::Learners::Classifiers::Linear
  
  require 'linear'
  
  @@classifiers = {}
  
  DefaultOptions = {
    bias: 1,
    eps: 0.1,
    solver_type: MCSVM_CS
  }
  
  def self.classify(entity, options = {})
    
    options = DefaultOptions.merge(options)
    set = options[:training]
    problem = set.problem
    
    if !@@classifiers[problem]
      labels = problem.question.labels
      unless labels
        raise Treat::Exception,
        "LibLinear requires that you provide the possible " +
        "labels to assign to classification items when " +
        "specifying the question."
      end
      param = LParameter.new
      param.solver_type = options[:solver_type]
      param.eps = options[:eps]
      bias = options[:bias]
      data = set.items.map do |item| 
        self.array_to_hash(item[:features]) 
      end
      prob = LProblem.new(labels, data, bias)
      @@classifiers[problem] = 
      LModel.new(prob, param)
    end

    @@classifiers[problem].predict(
    self.array_to_hash(problem.
    export_features(entity, false)))
    
  end
  
  def self.array_to_hash(array)
    hash = {}
    0.upto(array.length - 1) do |i|
      hash[i] = array[i]
    end
    hash
  end
  
end