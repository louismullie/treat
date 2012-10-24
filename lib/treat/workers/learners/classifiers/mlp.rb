# Classification based on a multilayer perceptron.
class Treat::Workers::Learners::Classifiers::MLP
  
  require 'ruby_fann/neural_network'
  
  DefaultOptions = {
    num_inputs: 3,
    hidden_neurons: [2, 8, 4, 3, 4],
    num_outputs: 1,
    max_neurons: 1000,
    neurons_between_reports: 1,
    desired_error: 0.1
  }
  
  @@classifiers = {}
  
  def self.classify(entity, options = {})
    options = DefaultOptions.merge(options)
    dset = options[:training]
    prob, items = dset.problem, dset.items
    if !@@classifiers[prob]
      fann = RubyFann::Standard.new(options)
      inputs = items.map { |it| it[:features][0..-2] }
      outputs = items.map { |it| [it[:features][-1]] }
      training = RubyFann::TrainData.new(
      inputs: inputs, desired_outputs: outputs)
      params = [options[:max_neurons],
      options[:neurons_between_reports],
      options[:desired_error]]
      fann.train_on_data(training, *params)
      @@classifiers[prob] = fann
    else
      fann = @@classifiers[prob]
    end
    vect = prob.export_features(entity, false)
    fann.run(vect)[0]
  end
  
end