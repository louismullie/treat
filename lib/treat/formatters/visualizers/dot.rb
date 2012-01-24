module Treat
  module Formatters
    module Visualizers
      class Dot
        # Border colors to use for different POS tags.
        BorderColors = {
          :verb => "#00AABB",
          :noun => "#FAD4A7",
          :adverb => '#103585',
          :adjective => '#D21D54'
        }
        # Create the top-most graph structure
        # and delegate the creation of the graph
        # nodes to to_dot.
        def self.visualize(entity, options = {})
          string = "graph {"
          string << self.to_dot(entity)
          string << "\n}"
        end
        # dot -Tpdf test4.dot > test4.pdf
        def self.to_dot(entity)
          string = ''
          if entity.is_leaf?
            if entity.is_a?(Treat::Entities::Word)
              label = "label=\"#{entity.value} (#{entity.tag})\","
              label << "color=\"#{BorderColors[entity.cat]}\","
            else
              label = "label=\"#{entity.value.inspect[1..-2]}\","
            end
          else
            if entity.class < Entities::Constituent
              label = "label=\"#{entity.tag}\","
              # label << "color=\"#{BorderColors[entity.tag]}\","
            else
              label = "label=\"#{cc(cl(entity.class))}\","
            end
          end
          string << "\n#{entity.id} ["
          if entity.has_features?
            string << label
            entity.features.each_pair do |feature, value|
              if value.is_a?(Treat::Entities::Entity)
                string << "#{feature}=\"#{value.id}\","
              else
                string << "#{feature}=\"#{value}\","
              end
            end
            string = string[0..-2]
            string << "]"
          else
            string << "#{label[0..-2]}]"
          end
          if entity.has_parent?
            string << "\n#{entity.parent.id} -- #{entity.id};"
          end
          if entity.has_children?
            entity.each do |child|
              string << self.to_dot(child)
            end
          end
          if entity.has_edges?
            entity.edges.each_pair do |target, type|
              string << "\n#{entity.id} -- #{target}"
              string << "[label=#{type},dir=forward,"
              string << "arrowhead=\"odiamond\"]"
            end
          end
          string
        end
      end
    end
  end
end
