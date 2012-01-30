module Treat
  module Processors
    module Parsers
      # A wrapper class for the Stanford parser.
      class Stanford
        require 'stanford-core-nlp'
        @@parser = {}
        DefaultOptions = {silence: false, log_to_file: nil, model: nil}
        # Parse the entity using the Stanford parser.
        #
        # Options:
        # - (String) :log_to_file => a filename to log output to
        # instead of displaying it.
        def self.parse(entity, options = {})
          options = DefaultOptions.merge(options)
          options[:log_to_file] = '/dev/null' if options[:silence]
          ::StanfordCoreNLP.log_file = options[:log_to_file] if options[:log_to_file]
          lang = Treat::Languages.describe(entity.language)
          ::StanfordCoreNLP.set_model('parser.model', "grammar/#{lang}PCFG.ser.gz")
          @@parser[lang] ||= ::StanfordCoreNLP.load(:tokenize, :ssplit, :pos, :lemma, :parse)
          text = ::StanfordCoreNLP::Text.new(entity.to_s)
          @@parser[lang].annotate(text)
          text.get(:sentences).each do |s|
            if entity.type == :sentence
              recurse(s.get(:tree), entity)
              # Fix - this could be made more robust.
            else
              c = entity << Treat::Entities::Sentence.from_string(s.to_s.strip)
              recurse(s.get(:tree), c)
            end
            #dep = s.get(:collapsed_c_c_processed_dependencies)
            #dep.vertexSet.each do |vertex|
            #  entity.each_word do |word|
            #    next unless word.to_s == vertex.word
                #puts vertex.begin_position
                #puts word.begin_index.to_s
                #puts vertex.index
                #puts vertex.hash_code
                #puts word.hash_code
                #puts 'yes' if vertex.hash_code == word.begin_index
             # end
            #end
          end
          entity
        end
        # Helper method which recurses the tree supplied by
        # the Stanford parser.
        def self.recurse(java_node, ruby_node)
          # Leaf
          if java_node.num_children == 0
            ruby_child = Treat::Entities::Entity.from_string(java_node.value.strip)
            label = java_node.label
            ruby_child.set :tag_set, :penn
            ruby_child.set :tag, label.get(:part_of_speech).to_s
            ruby_child.set :lemma, label.get(:lemma).to_s
            ruby_child.set :character_offset_begin, label.get(:character_offset_begin).to_s
            ruby_child.set :character_offset_end, label.get(:character_offset_end).to_s
            ruby_child.set :begin_index, label.get(:begin_index).to_s
            ruby_child.set :end_index, label.get(:end_index).to_s
            ruby_node << ruby_child
          else
            if java_node.num_children == 1
              return recurse(java_node.children[0], ruby_node)
            end
            java_node.children.each do |java_child|
              label = java_child.label
              ruby_child = Treat::Entities::Phrase.new
              ruby_child.set :tag_set, :penn
              ruby_child.set :tag, label.get(:category)
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