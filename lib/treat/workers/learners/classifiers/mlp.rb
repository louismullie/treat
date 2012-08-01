# Currently, this MLP is limited to 1 output.
class Treat::Workers::Learners::Classifiers::MLP
  
  require 'ai4r'
  
  @@mlps = {}
  
  def self.classify(entity, options = {})
    
    set = options[:training]
    cl = set.problem
      
    if !@@mlps[cl]
      net = Ai4r::NeuralNetwork::Backpropagation.new(
      [cl.feature_labels.size, 3, 1])
      set.items.each do |item|
        inputs = item[:features][0..-2]
        outputs = [item[:features][-1]]
        net.train(inputs, outputs)
      end
      @@mlps[cl] = net
    else
      net = @@mlps[cl]
    end
    
    net.eval(cl.export_features(entity, false))[0]
    
  end
  
end