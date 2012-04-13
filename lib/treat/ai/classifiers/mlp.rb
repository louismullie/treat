class Treat::AI::Classifiers::MLP
  
  require 'ai4r'
  
  @@mlps = {}
  
  def self.classify(entity, options = {})
    
    set = options[:training]
    cl = set.classification
      
    if !@@mlps[cl]
=begin
      ai4r_set = Ai4r::Data::DataSet.new(
        :data_items => set.items, 
        :data_labels => (
          set.labels.map { |l| l.to_s } + 
          [set.classification.question.to_s]
        )
      )
      net = Ai4r::Classifiers::MultilayerPerceptron.build(ai4r_set)
=end
      net = Ai4r::NeuralNetwork::Backpropagation.new([cl.labels.size, 3, 1])
      set.items.each do |item|
        net.train(item[0...-1], item[-1])
      end
      @@mlps[cl] = net
    else
      net = @@mlps[cl]
    end
    
    net.eval(cl.export_item(entity, false))
    
  end
  
end