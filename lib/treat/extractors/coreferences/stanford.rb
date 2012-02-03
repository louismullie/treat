module Treat
  module Extractors
    module Coreferences
      class Stanford
        require 'stanford-core-nlp'
        @@pipeline = nil
        def self.coreferences(entity, options = {})
          if entity.has_children?
            entity.print_tree
            raise Treat::Exception,
            "The Stanford Coreference Resolver " + "
            requires a unsegmented, untokenized block of text to work with."
          end
          @@pipeline ||=  ::StanfordCoreNLP.load(
            :tokenize, :ssplit, :pos, 
            :lemma, :parse, :ner, :dcoref
          )
          text = ::StanfordCoreNLP::Text.new(entity.to_s)
          @@pipeline.annotate(text)
          clusters = {}
          text.get(:sentences).each do |sentence|
            s = Treat::Entities::Sentence.from_string(sentence.get(:value).to_s)
            sentence.get(:tokens).each do |token|
              t = Treat::Entities::Token.from_string(token.value.to_s)
              tag = token.get(:named_entity_tag).to_s.downcase
              corefid = token.get(:coref_cluster_id).to_s
              t.set :named_entity_tag, tag.intern unless tag == 'o'
              t.set :coreference_cluster_id, corefid unless corefid == ''
              clusters[corefid] ||= []
              clusters[corefid] << t
              s << t
            end
            entity << s
          end
          entity.each_token do |token|
            if token.has?(:coreference_cluster_id)
              id = token.coreference_cluster_id
              links = clusters[id].dup
              links.delete(token)
              if links.empty?
                token.unset(:coreference_cluster_id)
                next
              end
              token.set :coreferences, links
              links.each do |target|
                token.link(target, :coreference)
              end
             # token.set :coreference_cluster_id, i
            end
          end
        end
      end
    end
  end
end