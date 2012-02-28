class Treat::Extractors::Coreferences::Stanford

  require 'treat/loaders/stanford'
  Treat::Loaders::Stanford.load

  @@pipeline = nil

  # Remove double iteration.
  def self.coreferences(entity, options = {})
    
    val = entity.to_s
    
    if entity.has_children?
      warn "The Stanford Coreference Resolver currently requires " +
      "an unsegmented, untokenized block of text to work with. " +
      "Removing and replacing all children of '#{entity.short_value}'."
      entity.remove_all!
    end
    
    @@pipeline ||=  ::StanfordCoreNLP.load(
      :tokenize, :ssplit, :pos,
      :lemma, :parse, :ner, :dcoref
    )
    
    s_phrases = []
    entity.each_phrase do |phrase|
      if phrase.has_children?
        p = ::StanfordCoreNLP.
        get_list(phrase.tokens)
      else
        p = phrase.to_s
      end
      s_phrases << p
    end
    
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

    entity.each_sentence do |sentence|

      n = 0
      named_entity_counts = {}

      sentence.each_token do |token|

        token.set :tag, token.get(:tag).to_s

        # Coreferences.
        if token.has?(:coref_cluster_id)
          n += 1
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
        
        # Named entity tag.
        if token.has?(:named_entity_tag)
          net = token.get(:named_entity_tag)
          named_entity_counts[net] ||= 0
          named_entity_counts[net] += 1
        end

      end

      sentence.set :coreference_count, n


      sentence.set :named_entity_counts,
      named_entity_counts

    end

    nil
    
  end

end
