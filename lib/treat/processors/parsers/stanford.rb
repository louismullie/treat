module Treat
  module Processors
    module Parsers
      class Stanford
        # Require the Ruby-Java bridge.
        silently { require 'rjb' }
        jar = "#{Treat.bin}/stanford_parser/stanford-parser.jar"
        unless File.readable?(jar)
          raise "Could not find stanford parser JAR file in #{jar}."+
          " You may need to set Treat.bin to a custom value."
        end
        Rjb::load(jar, ['-Xms256M', '-Xmx512M'])
        LexicalizedParser = ::Rjb::import('edu.stanford.nlp.parser.lexparser.LexicalizedParser')
        @@parsers = {}
        def self.parse(entity, options = {})
          lang = Treat::Resources::Languages.describe(entity.language).to_s
          pcfg = "#{Treat.bin}/stanford_parser/grammar/#{lang.upcase}PCFG.ser.gz"
          unless File.readable?(pcfg)
            raise "Could not find a language model for #{lang}: looking in #{pcfg}."
          end
          @@parsers[lang] ||= LexicalizedParser.new(pcfg) # Fix - check that exists.
          parse = @@parsers[lang].apply(entity.to_s)
          entity.remove_all!          
          recurse(parse, entity)
          entity
        end
        def self.recurse(java_node, ruby_node)
          # Leaf
          if java_node.num_children == 0
            ruby_child = Treat::Entities::Entity.from_string(java_node.value)
            labels = java_node.labels.iterator
            while labels.has_next
              label = labels.next
              ruby_child.set :begin_char, label.begin_position
              ruby_child.set :end_char, label.end_position
              ruby_child.set :tag, ruby_node.tag
            end
            ruby_node << ruby_child
          else
            if java_node.num_children == 1
              return recurse(java_node.children[0], ruby_node)
            end
            java_node.children.each do |java_child|
              dependencies = java_child.dependencies.iterator
              # while dependencies.has_next
                #dependency = dependencies.next
              # end
              ruby_child = Treat::Entities::Phrase.new
              ruby_child.set :tag, java_child.value 
              ruby_node << ruby_child
              unless java_child.children.empty?
                recurse(java_child, ruby_child)
              end
            end
          end
        end
      end
    end
  end
end