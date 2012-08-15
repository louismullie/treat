class Treat::Workers::Learners::Classifiers::SVM
  
  require 'libsvm'
  
  @@classifiers = {}

  DefaultOptions = {
    cache_size: 1,
    eps: 0.001,
    c: 10
  }
  
  # - (Numeric) :cache_size => cache size in MB.
  # - (Numeric) :eps => tolerance of termination criterion
  # - (Numeric) :c => C parameter
  def self.classify(entity, options = {})
    
    options = DefaultOptions.merge(options)
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
      examples = set.items.map  { |item| item[:features] }
      prob = Libsvm::Problem.new
      prob.set_examples(labels, examples)
      param = Libsvm::SvmParameter.new
      param.cache_size = options[:cache_size]
      param.eps = options[:eps]
      param.c = options[:c]
      model = Libsvm::Model.train(problem, parameter)
      @@classifiers[problem] = model
    end
    
    features = problem.export_features(entity, false)
    
    @@classifiers[problem].predict(
    Libsvm::Node.features(*features))
    
  end
  
end