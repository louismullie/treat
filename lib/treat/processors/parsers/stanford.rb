module Treat
  module Processors
    module Parsers
      # A wrapper class for the Stanford parser.
      class Stanford
        require 'stanford-core-nlp'
        @@parser = {}
        DefaultOptions = {
          :silence => false, 
          :log_to_file => nil, 
          :parser_model => nil,
          :tagger_model => nil
        }
        # Parse the entity using the Stanford parser.
        #
        # Options:
        # - (String) :log_to_file => a filename to log output to
        # instead of displaying it.
        def self.parse(entity, options = {})
          options = DefaultOptions.merge(options)
          lang = entity.language
          StanfordCoreNLP.use(lang)
          if options[:tagger_model]
            ::StanfordCoreNLP.set_model(
              'pos.model', options[:tagger_model]
            )
          end
          if options[:parser_model]
            ::StanfordCoreNLP.set_model(
              'parser.model', options[:parser_model]
            )
          end
          if options[:silence]
            options[:log_to_file] = '/dev/null'
          end
          if options[:log_to_file]
            ::StanfordCoreNLP.log_file = 
              options[:log_to_file] 
          end
          @@parser[lang] ||= 
            ::StanfordCoreNLP.load(
              :tokenize, :ssplit, :pos, :lemma, :parse
            )
          text = ::StanfordCoreNLP::Text.new(entity.to_s)
          @@parser[lang].annotate(text)
          
          text.get(:sentences).each do |s|
            if entity.is_a?(Treat::Entities::Sentence) ||
              entity.is_a?(Treat::Entities::Phrase)
              tag = s.get(:category).to_s
              tag_s, tag_opt = *tag.split('-')
              tag_s ||= 'S'
              entity.set :tag_set, :penn
              entity.set :tag, tag_s
              entity.set :tag_opt, tag_opt if tag_opt
              recurse(s.get(:tree), entity)
              break
            else
              recurse(s.get(:tree), entity)
            end
          end
        end
        
        # Helper method which recurses the tree supplied by
        # the Stanford parser.
        def self.recurse(java_node, ruby_node, additional_tags = [])
          # Leaf
          if java_node.num_children == 0
            label = java_node.label
            tag = label.get(:part_of_speech).to_s
            tag_s, tag_opt = *tag.split('-')
            tag_s ||= ''
            ruby_node.value = java_node.value.to_s.strip
            ruby_node.set :tag_set, :penn
            ruby_node.set :tag, tag_s
            ruby_node.set :tag_opt, tag_opt if tag_opt
            ruby_node.set :tag_set, :penn
            ruby_node.set :lemma, label.get(:lemma).to_s
            
            ruby_node.set :character_offset_begin, 
            label.get(:character_offset_begin).to_s
            
            ruby_node.set :character_offset_end, 
            label.get(:character_offset_end).to_s
            
            ruby_node.set :begin_index, 
            label.get(:begin_index).to_s
            
            ruby_node.set :end_index, 
            label.get(:end_index).to_s
            
            additional_tags.each do |t|
              lt = label.get(t)
              ruby_node.set t, lt.to_s if lt
            end
            return ruby_node
          else

            if java_node.num_children == 1 &&
              java_node.children[0].num_children == 0
              recurse(java_node.children[0], ruby_node, additional_tags)
              return
            end

            java_node.children.each do |java_child|
              label = java_child.label
              tag = label.get(:category).to_s
              tag_s, tag_opt = *tag.split('-')
              tag_s ||= ''
              
              if Treat::Languages::Tags::PhraseTagToCategory[tag_s]
                ruby_child = Treat::Entities::Phrase.new
              else
                l = java_child.children[0].to_s
                v = java_child.children[0].value.to_s.strip
                # Mhmhmhmhmhm
                val = (l == v) ? v :  l.split(' ')[-1].gsub(')', '')
                ruby_child = Treat::Entities::Token.from_string(val)
              end

              ruby_child.set :tag_set, :penn
              ruby_child.set :tag, tag_s
              ruby_child.set :tag_opt, tag_opt if tag_opt
              ruby_node << ruby_child

              unless java_child.children.empty?
                recurse(java_child, ruby_child, additional_tags)
              end
            end
          end
        end
      end
    end
  end
end
