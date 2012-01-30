module Treat
  module Formatters
    module Visualizers
      class Dot
        DefaultOptions = {colors: {}, :features => :all, :first => true}
        # Create the top-most graph structure
        # and delegate the creation of the graph
        # nodes to to_dot.
        def self.visualize(entity, options = {})
          options = DefaultOptions.merge(options)
          string = "graph {"
          string << self.to_dot(entity, options)
          string << "\n}"
        end
        # dot -Tpdf test4.dot > test4.pdf
        def self.to_dot(entity, options)
          # Id
          string = ''
          label = ''
          string = "\n#{entity.id} ["
          label = "#{entity.type.to_s.capitalize}\\n\\\"#{entity.short_value}\\\""
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
          label = label[0..-2] if label[-1] == ','
          string << "label=\"#{label}\"]"
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
