module Treat
  module Extractors
    module Coreferences
      class Stanford
        require 'stanford-core-nlp'
        @@pipeline = nil
        def self.coreferences(entity, options = {})
         # puts entity.to_s
          if entity.has_children?
            raise "The Stanford Coreference Resolver currently requires " +
            "an unsegmented, untokenized block of text to work with. " +
            "Removing and replacing all children of '#{entity.short_value}'."
          end
          @@pipeline ||=  ::StanfordCoreNLP.load(
          :tokenize, :ssplit, :pos,
          :lemma, :parse, :ner, :dcoref
          )
          text = ::StanfordCoreNLP::Text.new(entity.to_s)
          @@pipeline.annotate(text)
          clusters = {}
          text.get(:sentences).each do |sentence|
            s = Treat::Entities::Sentence.
            from_string(sentence.get(:value).to_s, true)
            sentence.get(:tokens).each do |token|
              t = Treat::Entities::Token.
              from_string(token.value.to_s)
              tag = token.get(:named_entity_tag).
              to_s.downcase
              corefid = token.get(:coref_cluster_id).to_s
              unless corefid == ''
                clusters[corefid] ||= []
                clusters[corefid] << t
                t.set :coref_cluster_id, corefid
              end

              t.set :named_entity_tag,
              tag.intern unless tag == 'o'
              s << t
            end
            entity << s
          end
          entity.each_token do |token|
            if token.has?(:coref_cluster_id)
              id = token.coref_cluster_id
              links = clusters[id].dup
              links.delete(token)
              token.unset(:coref_cluster_id)
              next if links.empty?
              token.set :coreferents, links
              links.each do |target|
                token.link(target, :refers_to)
              end
            end
          end
          i = 0
          coreferences = {}
          clusters.each do |k,v|
            unless !v || v.size == 1
              coreferences[i] = v
              i += 1
            end
          end
          coreferences
        end
      end
    end
  end
end
