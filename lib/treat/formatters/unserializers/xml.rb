module Treat
  module Formatters
    module Unserializers
      # Recreates the entity tree corresponding to
      # a serialized XML file.
      class XML
        require 'nokogiri'
        # Unserialize an entity stored in XML format.
        #
        # Options: none.
        def self.unserialize(document, options = {})
          # Read in the XML file.
          xml = File.read(document.file)
          xml.gsub!('<treat>', '')
          xml.gsub!('</treat>', '')
          xml_reader = Nokogiri::XML::Reader.from_memory(xml)
          current_element = nil
          previous_depth = 0

          # Read the XML file entity by entity.
          while xml_reader.read
            # The depth in the XML tree.
            current_depth = xml_reader.depth
            # If we are at the end of the children stack, pop up.
            if previous_depth > current_depth && current_depth != 0
              current_element = current_element.parent
            end
            # If an end element has been reached,
            # change the depth and pop up on next
            # iteration.
            if xml_reader.node_type ==
              Nokogiri::XML::Reader::TYPE_END_ELEMENT
              previous_depth = current_depth
              next
            end

            id = nil; value = ''
            attributes = {}
            dependencies = []
            unless xml_reader.attributes.size == 0
              xml_reader.attributes.each_pair do |k,v|
                if k == 'id'
                  id = v.to_i
                elsif k == 'dependencies'
                  a = v.split('--')
                  a.each do |b|
                    c = b.split(';')
                    c.each do |dep|
                      vals = []
                      dep.split(',').each do |name_val|
                        name_val = name_val[0..-2] if name_val[-1] == '}'
                        d =  name_val.split(':')[1]
                        vals << d.strip if d
                      end
                      
                      target, type, directed, direction = *vals
                      dependencies << [
                          target.to_i, 
                          type,
                          (directed == 'true' ? true : false),
                          direction.to_i
                      ]
                    end
                  end
                elsif k == 'value'
                  value = v
                else
                  attributes[k.intern] = v
                end
              end
            end

            current_value = ''
            type = xml_reader.name.intern

            if Treat::Entities.list.include?(type)
              if !current_element
                current_element = self.revive(type, current_value, id)
              else
                current_element = current_element <<
                self.revive(type, current_value, id)
              end
              current_element.features = attributes
              current_element.features = attributes
              dependencies.each do |dependency|
                target, type, directed, direction = *dependency
                current_element.link(target, type, directed, direction)
              end
            else
              current_value = xml_reader.value ?
              xml_reader.value.strip : ''
              if current_value && current_value != ''
                current_element.value = current_value
                current_element.register_token(current_element)
              end
            end

            previous_depth = current_depth
          end
          document << current_element
          document
        end

        def self.revive(type, value, id)
          klass = Treat::Entities.const_get(cc(type))
          klass.new(value, id)
        end

      end
    end
  end
end
