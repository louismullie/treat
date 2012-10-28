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
    dset = options[:training]
    prob, items = dset.problem, dset.items
    if !@@classifiers[prob]
      lparam = LParameter.new
      lparam.solver_type = options[:solver_type]
      lparam.eps = options[:eps]
      lbls = items.map { |it| it[:features][-1] }
      exs = items.map { |it| it[:features][0..-2] }.
      map { |ary| self.array_to_hash(ary) }
      lprob = LProblem.new(lbls, exs, options[:bias])
      model = LModel.new(lprob, lparam)
      @@classifiers[prob] = model
    end
    features = prob.export_features(entity, false)
    @@classifiers[prob].predict(
    self.array_to_hash(features))
  end
  
  def self.array_to_hash(array)
    hash = {}
    0.upto(array.length - 1) do |i|
      hash[i] = array[i]
    end
    hash
  end
  
end