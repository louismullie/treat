module Treat
  module Formatters
    module Visualizers
      class Dot
        DefaultOptions = {
          :colors => {}, 
          :features => :all, 
          :file => nil,
          :filter_out => [],
          :colors => nil,
          :first => true # For internal purposes only.
        }
        # Create the top-most graph structure
        # and delegate the creation of the graph
        # nodes to to_dot.
        def self.visualize(entity, options = {})
          options = DefaultOptions.merge(options)
          string = "graph {"
          string << self.to_dot(entity, options)
          string << "\n}"
          if options[:file]
            File.open(options[:file], 'w') { |f| f.write(string) }
          end
          string
        end
        # dot -Tpdf test4.dot > test4.pdf
        def self.to_dot(entity, options)
          # Filter out specified types.
          match_types = lambda do |t1, t2s|
            f = false
            t2s.each { |t2| f = true if Treat::Entities.match_types[t1][t2] }
            f
          end
          return '' if match_types.call(entity.type, options[:filter_out])
          # Id
          string = ''
          label = ''
          sv = entity.short_value.inspect[1..-2]
          string = "\n#{entity.id} ["
          label = "#{entity.type.to_s.capitalize}\\n\\\"#{sv}\\\""
          label.gsub!(' [...]', " [...] \\n")
          # Features
          if entity.has_features?
            unless options[:features] == :none
              label << "\\n"
              entity.features.each do |feature, value|
                if options[:features] == :all ||
                  options[:features].include?(feature)
                  if value.is_a?(Treat::Entities::Entity)
                    label << "\\n#{feature}:  \\\"*#{value.id}\\\""
                  elsif value.is_a?(Hash)
                    label << "\\n#{feature}: \\n\{ "
                    value.each do |k,v|
                      v = v ? v.inspect : ' -- '
                      v.gsub!('[', '\[')
                      v.gsub!('{', '\}')
                      v.gsub!(']', '\]')
                      v.gsub!('}', '\}')
                      v.gsub!('"', '\"')
                      label <<  "#{k}: #{v},\\n"
                    end
                    label = label[0..-4] unless label[-2] == '{'
                    label << "\},"
                  elsif value.is_a?(Array)
                    label << "\\n#{feature}: \\n\[ "
                    value.each do |e|
                      e = "*#{e.id}" if e.is_a?(Treat::Entities::Entity)
                      label << "#{e},\\n"
                    end
                    label = label[0..-4] unless label[-2] == '['
                    label << " \]"
                  else
                    label << "\\n#{feature}:  \\\"#{value}\\\""
                  end
                end
              end
            end
          end
          color = nil
          if options[:colors]
            options[:colors].each do |col, lambda|
              color = col.to_s if lambda.call(entity)
              break if color
            end
          end
          label = label[0..-2] if label[-1] == ','
          string << "label=\"#{label}\",color=\"#{color.to_s}\"]"
          string.gsub!('\\\\""]', '\\""]')
          string.gsub('\"\""]', '\""]')
          # Parent-child relationships.
          if entity.has_parent?
            unless options[:first] == true
              string << "\n#{entity.parent.id} -- #{entity.id};" 
            end
          end
          # Edges.
          if entity.has_edges?
            entity.edges.each_pair do |target, type|
              string << "\n#{entity.id} -- #{target}"
              string << "[label=#{type},dir=forward,"
              string << "arrowhead=\"odiamond\"]"
            end
          end
          # Recurse.
          options[:first] = false
          if entity.has_children?
            entity.each do |child|
              string << self.to_dot(child, options)
            end
          end
          string
        end
      end
    end
  end
end
