module Treat
  module Processors
    module Parsers
      # The Enju class is a wrapper for the Enju syntactic
      # parser for English. Given a file or string input,
      # the parser formats it runs it through Enju, and
      # parses the XML output by Enju using the Nokogiri
      # XML reader. It creates wrappers for the sentences,
      # syntactical phrases and  tokens that Enju identified.
      #
      # Original paper:
      # Takuya Matsuzaki, Yusuke Miyao, and Jun'ichi Tsujii.
      # 2007. Efficient HPSG Parsing with Supertagging and
      # CFG-filtering. In Proceedings of IJCAI 2007.
      class Enju
        # Require the 'open13' library for interaction
        # with the background Enju process.
        require 'open3'
        @@parsers = []
        @@i = 0
        # Require the Nokogiri XML parser.
        require 'nokogiri'
        # Return the process running Enju.
        def self.proc
          if @@parsers.size < @@options[:processes]
            @@parsers << ::Open3.popen3("enju -xml -i")
          end
          @@i += 1
          @@i = 0 if @@i == @@parsers.size
          @@parsers[@@i-1]
        end
        # Parse the entity into its syntactical phrases
        # using Enju
        def self.parse(entity, options = {})
          options[:processes] ||= 1
          @@options = options
          stdin, stdout = proc
          if entity.to_s.count('.') == 0
            remove_last = true
            text = entity.to_s + '.'
          else
            remove_last = false
            text = entity.to_s.gsub('.', '')
            text += '.' unless ['!', '?'].include?(text[-1])
          end
          stdin.puts(text + "\n")
          parsed = build(stdout.gets, remove_last)
          if not parsed.nil?
            entity.remove_all!
            parsed.children.each do |child|
              entity << child
            end
          else
            warn "Couldn't parse the text '#{entity.to_s}'."
          end
          entity
        end
        # Parses an Enju XML output file using the Nogoriki
        # XML reader and converts that structure into a tree
        # of wrappers for textual entities.
        def self.build(xml, remove_last = false)
          # Read in the XML file.
          xml_reader = Nokogiri::XML::Reader.from_memory(xml)
          current_element = nil
          previous_depth = 0
          id_table = {}
          edges_table = {}
          # Read the XML file entity by entity.
          while xml_reader.read
            # The depth in the XML tree.
            current_depth = xml_reader.depth
            # If we are at the end of the children stack, pop up.
            if previous_depth > current_depth
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
            attributes = xml_reader.attributes
            prefix = ['schema', 'lexentry', 'type']
            # If the entity has entributes, add them.
            unless attributes.empty?
              new_attributes = {}
              edges = {}
              id = attributes.delete('id')
              pred = attributes.delete('pred')
              attributes.each_pair do |attribute, value|
                if ['arg1', 'arg2'].include?(attribute)
                  edges[value] = pred
                else
                  if attribute == 'cat'
                    if xml_reader.name == 'tok'
                      if value.length > 1 && ['P', 'X'].include?(value[-1]) &&
                        value != 'PN'
                        new_attributes[:saturated] = (value[-1] == 'P')
                        value = value[0..-2]
                      end
                      cat = Treat::Languages::English::EnjuCatToCategory[value]
                      new_attributes[:cat] = cat
                    else
                      new_attributes[:enju_cat] = value
                      xcat = attributes['xcat'].split(' ')[0]
                      xcat ||= ''
                      tags = Treat::Languages::English::EnjuCatXcatToPTB.select do |m|
                        m[0] == value && m[1] == xcat
                      end
                      if tags.empty?
                        tag = 'UK'
                      else
                        tag = tags[0][2]
                      end
                      new_attributes[:enju_xcat] = xcat
                      attributes.delete('xcat')
                      new_attributes[:tag] = tag
                    end
                  else
                    pre = prefix.include?(attribute) ? 'enju_' : ''
                    new_attributes[:"#{pre+attribute}"] = value
                  end
                end
              end
              attributes.delete('arg1')
              attributes.delete('arg2')
            end
            # Handle naming conventions.
            if attributes.has_key?('pos')
              new_attributes[:tag] = new_attributes[:pos]
              new_attributes[:tag_set] = :penn
              new_attributes.delete :pos
            end
            if attributes.has_key?('base')
              new_attributes[:lemma] = new_attributes[:base]
              new_attributes.delete :base
            end
            # Create the appropriate entity for the
            # element.
            current_value = ''
            attributes = new_attributes
            case xml_reader.name
            when 'sentence'
              current_element = Treat::Entities::Sentence.new('')
              id_table[id] = current_element.id
              edges_table[current_element.id] = edges
              current_element.features = attributes
            when 'cons'
              current_element = current_element <<
              Treat::Entities::Phrase.new('')
              id_table[id] = current_element.id
              edges_table[current_element.id] = edges
              current_element.features = attributes
            when 'tok'
              tmp_attributes = attributes
              tmp_edges = edges
            else
              current_value = xml_reader.value.gsub(/\s+/, "")
              if !current_value.empty?
                current_element = current_element <<
                Treat::Entities::Entity.from_string(current_value)
                if current_element.is_a?(Treat::Entities::Word)
                  current_element.features = tmp_attributes
                  id_table[id] = current_element.id
                  edges_table[current_element.id] = tmp_edges                  
                end
              end
            end
            previous_depth = current_depth
          end
          # Add the edges to the entity.
          unless current_element.nil?
            root = current_element.root
            edges_table.each_pair do |id2, edges2|
              # Next if there are no edges.
              next if edges2.nil?
              entity = root.find(id2)
              edges2.each_pair do |argument, type|
                # Skip this argument if we don't know
                # the target node.
                next if argument == 'unk'
                entity.associate(id_table[argument], type)
              end
            end
            # Link the head and sem_head to their entities.
            root.each_phrase do |phrase|
              phrase.set :head,
              root.find(id_table[phrase.head])
              phrase.set :sem_head,
              root.find(id_table[phrase.sem_head])
            end
          end
          # Remove the period we added at the end.
          if remove_last
            last = current_element.punctuations[-1]
            current_element.remove!(last)
          end
          current_element
        end
      end
    end
  end
end
