module Treat
  module Extractors
    module Statistics
      # Experimental algorithm to calculate the transition
      # probability of an observed word.
      class TransitionProbability

        # Find the transition probability.
        def self.statistics(entity, options={})
          tm = options[:transition_matrix]
          features = tm.keys
          score = 0
          count = 0

          relationships = [:parent, :left, :right, :children]
          
          features.each do |f1|
            v1 = entity.send(f1)
            features.each do |f2|
              next unless tm[f1][v1]
              
              relationships.each do |relationship|
                relatives = entity.send(relationship)
                relatives = [relatives] unless relatives.is_a? Array
                relatives.each do |relative|
                  next if relative.nil? || !relative.has?(f2)
                  v2 = relative.send(f2)
                  if tm[f1][v1][relationship] && 
                    tm[f1][v1][relationship][f2] && 
                    tm[f1][v1][relationship][f2][v2]
                      score += tm[f1][v1][relationship][f2][v2]
                      count += 1
                  end
                end
              end

              entity.edges.each do |id, edge|
                s = entity.ancestor_with_type :sentence
                if s
                  x = s.find(id)
                  next unless h.has?(f2)
                  v2 = x.send(f2)
                  if tm[f1][v1][:edge][f2][v2]
                    score += tm[f1][v1][:edge][f2][v2]
                    count += 1
                  end
                end
              end

            end
          end
          score.to_f/count.to_f
        end
      end
    end
  end
end
