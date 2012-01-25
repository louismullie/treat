module Treat
  module Formatters
    module Serializers
      # This class converts an entity to a storable XML format.
      class XML
        # Reauire the Nokogiri XML parser.
        require 'nokogiri'
        # Serialize an entity tree in XML format.
        def self.serialize(entity, options = {})
          options = {:indent => 0} if options[:indent].nil?
          if options[:indent] == 0
            string = '<?xml version="1.0" encoding="UTF-8" standalone="no" ?>'
          else
            string = ''
          end
          spaces = ''
          options[:indent].times { spaces << ' ' }
          attributes = ''
          if !entity.features.nil? && entity.features.size != 0
            attributes = ' '
            entity.features.each_pair do |feature, value|
              if value.is_a? Entities::Entity
                attributes << "#{feature}='#{value.id}' "
              else
                attributes << "#{feature}='#{value}' "
              end
            end
            entity.edges.each_pair do |id,edge|
              attributes << "#{edge}='#{id}' "
            end
          end
          tag = entity.class.to_s.split('::')[-1].downcase
          string += "\n#{spaces}<#{tag}#{attributes[0..-2]}>"
          if entity.has_children?
            options[:indent] += 1
            entity.children.each do |child| 
              string = string + serialize(child, options)
            end
            options[:indent] -= 1
          else
            string = string + "\n#{spaces}#{entity.value}"
          end
          string + "\n#{spaces}</#{tag}>"
        end
      end
    end
  end
end