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
        # Parse the entity into its syntactical phrases using Enju.
        # Calls #build to initiate XML parsing.
        def self.parse(entity, options = {})
          options[:processes] ||= 1
          @@options = options
          @@id_table = {}
          @@edges_table = {}
          stdin, stdout = proc
          text, remove_last = valid_text(entity)
          stdin.puts(text + "\n")
          parsed = build(stdout.gets, remove_last)
          if not parsed.nil?
            entity.remove_all!
            parsed.children.each do |child|
              entity << child
            end
            # Remove the period we added at the end.
            if remove_last
              last = entity.punctuations[-1]
              entity.remove!(last)
            end
          else
            warn "Couldn't parse the text '#{entity.to_s}'."
          end
          link_heads(entity)
          add_edges(entity)
        end
        # Parses an Enju XML output file using the Nogoriki
        # XML reader and converts that structure into a tree
        # of wrappers for textual entities.
        def self.build(xml, remove_last = false)
          # Read in the XML file.
          xml_reader = Nokogiri::XML::Reader.from_memory(xml)
          current_element = nil
          previous_depth = 0
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
            # Get and format attributes and edges.
            attributes = xml_reader.attributes
            id = attributes.delete('id')
            new_attributes = {}; edges = {}
            unless attributes.size == 0
              new_attributes, edges =
              cleanup_attributes(xml_reader.name, attributes)
            end
            # Create the appropriate entity for the
            # element.
            current_value = ''
            case xml_reader.name
            when 'sentence'
              current_element = Treat::Entities::Sentence.new('')
              @@id_table[id] = current_element.id
              @@edges_table[current_element.id] = edges
              current_element.features = new_attributes
            when 'cons'
              current_element = current_element <<
              Treat::Entities::Phrase.new('')
              @@id_table[id] = current_element.id
              @@edges_table[current_element.id] = edges
              current_element.features = new_attributes
            when 'tok'
              tmp_attributes = new_attributes
              tmp_edges = edges
            else
              current_value = xml_reader.value.gsub(/\s+/, "")
              unless current_value.size == 0
                current_element = current_element <<
                Treat::Entities::Token.from_string(current_value)
                if current_element.is_a?(Treat::Entities::Word)
                  current_element.features = tmp_attributes
                  @@id_table[id] = current_element.id
                  @@edges_table[current_element.id] = tmp_edges
                end
              end
            end
            previous_depth = current_depth
          end
          current_element
        end
        # Validate a text - Enju wants period to parse a sentence.
        def self.valid_text(entity)
          if entity.to_s.count('.') == 0
            remove_last = true
            text = entity.to_s + '.'
          else
            remove_last = false
            text = entity.to_s.gsub('.', '')
            text += '.' unless ['!', '?'].include?(text[-1])
          end
          return text, remove_last
        end
        # Link the head and sem_head to their entities.
        def self.link_heads(entity)
          entity.each_phrase do |phrase|
            if phrase.has?(:head)
              phrase.set :head,
              entity.find(@@id_table[phrase.head])
            end
            if phrase.has?(:sem_head)
              phrase.set :sem_head,
              entity.find(@@id_table[phrase.sem_head])
            end
          end
        end
        # Add edges a posterior to a parsed entity.
        def self.add_edges(entity2)
          entity2.each_entity(:word, :phrase) do |entity|
            @@edges_table.each_pair do |id2, edges2|
              # Next if there are no edges.
              next if edges2.nil?
              entity = entity2.find(id2)
              edges2.each_pair do |argument, type|
                # Skip this argument if we don't know the target node.
                next if argument == 'unk'
                entity.link(@@id_table[argument], type)
              end
            end
          end
        end
        # Helper function to convert Enju attributes to Treat attributes.
        def self.cleanup_attributes(name, attributes)
          new_attributes = {}
          edges = {}
          pred = attributes.delete('pred')
          attributes.each_pair do |attribute2, value|
            attribute = attribute2.strip
            if attribute == 'arg1' || attribute == 'arg2'
              edges[value] = pred
              next
            end
            if attribute == 'cat'
              if name == 'tok'
                if value.length > 1 && ['P', 'X'].include?(value[-1]) &&
                  value != 'PN'
                  new_attributes[:saturated] = (value[-1] == 'P')
                  value = value[0..-2]
                end
                new_attributes[:category] =
                Treat::Languages::English::EnjuCatToCategory[value]
              else
                tags = Treat::Languages::English::EnjuCatXcatToPTB.select do |m|
                  m[0] == value && m[1] == attributes['xcat']
                end
                tag = (tags.size == 0) ? 'UK' : tags[0][2]
                new_attributes[:tag] = tag
              end
            else
              new_attributes[:"#{attribute}"] = value
            end
          end
          # Delete after iteration.
          attributes.delete('arg1')
          attributes.delete('arg2')
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
          return new_attributes, edges
        end
      end
    end
  end
end
