module Treat
  module Formatters
    module Serializers
      # This class converts an entity to a storable XML format.
      class XML
        # Reauire the Nokogiri XML parser.
        require 'nokogiri'
        # Serialize an entity tree in XML format.
        #
        # Options:
        # - (String) :file => a file to write to.
        def self.serialize(entity, options = {})
          options = options.merge({:indent => 0}) if options[:indent].nil?
          indent = options[:indent]
          if options[:indent] == 0
            #enc = entity.encoding(:r_chardet19).to_s.gsub('_', '-').upcase
            string = "<?xml version=\"1.0\" encoding=\"utf-8\" standalone=\"no\" ?>\n<treat>"
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
          unless entity.is_a?(Treat::Entities::Token)
            string += "\n" 
          end
          string += "#{spaces}<#{tag}#{attributes[0..-2]}>"
          if entity.has_children?
            options[:indent] += 1
            entity.children.each do |child|
              string =
              string +
              serialize(child, options)
            end
            options[:indent] -= 1
          else
            string = string + "#{entity.value}"
          end
          unless entity.is_a?(Treat::Entities::Token)
            string += "\n#{spaces}"
          end
          string += "</#{tag}>"
          if indent == 0
            string += "\n</treat>"
            if options[:file]
              File.open(options[:file], 'w') { |f| f.write(string) }
            end
            # puts string
          end
          string
        end
      end
    end
  end
end
