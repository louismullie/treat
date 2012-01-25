module Treat
  module Extractors
    module Statistics
      # Experimental algorithm to generate transition matrices.
      class TransitionMatrix
        DefaultOptions = {
          normalize: true,
          features: [:tag],
          condition: lambda { |e| true },
          entity_types: [:word],
          relationships: [:parent, :right, :children]
        }
        # Find the transition matrix.
        def self.statistics(entity, options={})
          options = DefaultOptions.merge(options)

          # Create lambdas to generate the arrays.
          empty_prototype = {}; options[:features].each { |f| empty_prototype[f] = {} }
          empty = lambda { Marshal.load(Marshal.dump(empty_prototype)) }
          empty2_prototype = {}; options[:relationships].each { |r| empty2_prototype[r] = empty.call }
          empty2 = lambda { Marshal.load(Marshal.dump(empty2_prototype)) }

          # Deep (recursive) merger.
          merger = lambda do |key,v1,v2|
            Hash === v1 && Hash === v2 ? v1.merge(v2, &merger) : v2
          end

          # Master matrix.
          mm = nil
          tm = empty.call

          entity.each_entity(*options[:entity_types]) do |target|

            next unless options[:condition].call(target)

            # Initialize the empty transition matrix.
            

            # Calculate the transition probabilities.
            options[:features].each do |f1|

              v1 = target.send(f1)
              tm[f1][v1] = empty2.call

              options[:relationships].each do |relationship|
                tm[f1][v1][relationship] = empty.call

                options[:features].each do |f2|
                  relatives = target.send(relationship)
                  relatives = [relatives] unless relatives.is_a? Array
                  relatives.each do |relative|
                    unless relative.nil?
                      next if relative.nil? || !relative.has?(f2)
                      v2 = relative.send(f2)
                      tm[f1][v1][relationship][f2][v2] ||= 0.0
                      tm[f1][v1][relationship][f2][v2] += 1.0
                    end
                  end

                  tm[f1][v1][:edge] = empty.call

                  target.edges.each do |id, edge_type|
                    s = target.ancestor_with_type :sentence
                    if s
                      x = s.find(id)
                      next unless relative.has?(f2)
                      v2 = x.send(f2)
                      tm[f1][v1][:edge][f2][v2] ||= 0.0
                      tm[f1][v1][:edge][f2][v2] += 1.0
                    end
                  end

                end
              end
            end
          end
          mm = mm ? mm.merge(tm, &merger) : tm
          if options[:normalize]
            normalize(mm)
          else
            mm
          end
        end

        # Normalize the transition probabilities.
        def self.normalize(tm)
          tm.each do |f1, as|
            as.each do |a, dirs|
              dirs.each do |dir, f2s|
                f2s.each do |f2, vals|
                  sum = vals.values.inject(0) {|n,x| n+x }.to_f
                  vals.each do |val, count|
                    vals[val] = count/sum
                  end
                end
              end
            end
          end
          tm
        end

      end
    end
  end
end
