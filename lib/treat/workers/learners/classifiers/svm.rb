class Treat::Workers::Learners::Classifiers::SVM
  
  require 'libsvm'
  
  @@classifiers = {}

  DefaultOptions = {
    cache_size: 1, # in MB
    eps: 0.001,
    c: 10
  }
  
  # - (Numeric) :cache_size => cache size in MB.
  # - (Numeric) :eps => tolerance of termination criterion
  # - (Numeric) :c => C parameter
  def self.classify(entity, options = {})
    options = DefaultOptions.merge(options)
    dset = options[:training]
    prob, items = dset.problem, dset.items
    if !@@classifiers[prob]
      labels = prob.question.labels
      if !labels || labels.empty?
        raise Treat::Exception,
        "LibSVM requires that you provide the possible " +
        "labels to assign to classification items when " +
        "specifying the question."
      end
      lprob = Libsvm::Problem.new
      lparam = Libsvm::SvmParameter.new
      lparam.cache_size = options[:cache_size]
      lparam.eps = options[:eps]
      lparam.c = options[:c]
      llabels = items.map { |it| it[:features][-1] }
      lexamples = items.map { |it| it[:features][0..-2] }.
      map { |ary| Libsvm::Node.features(ary) }
      lprob.set_examples(llabels, lexamples)
      model = Libsvm::Model.train(lprob, lparam)
      @@classifiers[prob] = model
    end
    features = prob.export_features(entity, false)
    @@classifiers[prob].predict(
    Libsvm::Node.features(features))
  end
  
end