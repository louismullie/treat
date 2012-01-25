module Treat
  module Formatters
    module Visualizers
      class Dot
        DefaultOptions = {colors: {}, :features => :all}
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
          # Value
          if entity.is_a?(Treat::Entities::Token)
            label = entity.to_s
          else
            label = entity.type.to_s.capitalize + " "
            if entity.is_leaf?
              label = entity.short_value.gsub(' [...]', " [...] \\n")
            end
          end
          # Features
          if entity.has_features?
            unless options[:features] == :none
              label << "\\n"
              entity.features.each do |feature, value|
                if options[:features] == :all ||
                  options[:features].include?(feature)
                  if value.is_a?(Treat::Entities::Entity)
                    label << "\\n#{feature}=\\\"*#{value.id}\\\","
                  else
                    label << "\\n#{feature}=\\\"#{value}\\\","
                  end
                end
              end
            end
          end
          label = label[0..-2] if label[-1] == ','
          string << "label=\"#{label}\"]"
          # Parent-child relationships.
          if entity.has_parent?
            string << "\n#{entity.parent.id} -- #{entity.id};"
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
