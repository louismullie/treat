# Detects the named entity tag in sentences by using
# the stanford-core-nlp gem, which interfaces with
# the Stanford Deterministic Coreference Resolver.
class Treat::Extractors::NameTag::Stanford

  require 'treat/loaders/stanford'
  Treat::Loaders::Stanford.load
  
  StanfordCoreNLP.load_class('ArrayList', 'java.util')
  StanfordCoreNLP.load_class('Word', 'edu.stanford.nlp.ling')
  
  @@pipelines = {}

  def self.name_tag(entity, options = {})
    
    pp = nil
    
    # If it's a token, then call the function
    # on the parent phrase. Otherwise, call the
    # function on all the text contained within
    # the entity.
    if entity.is_a?(Treat::Entities::Token) &&
      entity.has_parent?
      pp = entity.parent_phrase
      s = get_list(pp.tokens)
    else
      s = entity.to_s
    end
    
    lang = entity.language

    @@pipelines[lang] ||=  
    ::StanfordCoreNLP.load(
      :tokenize, :ssplit, :pos, 
      :lemma, :parse, :ner
    )

    text = ::StanfordCoreNLP::Text.new(s)
    @@pipelines[lang].annotate(text)

    add_to = pp ? pp : entity

    if entity.is_a?(Treat::Entities::Phrase)
      text.get(:tokens).each do |token|
        t = Treat::Entities::Token.
        from_string(token.value.to_s)
        tag = token.get(:named_entity_tag).
              to_s.downcase
        t.set :named_entity_tag, 
        tag.intern unless tag == 'o'
        add_to << t
      end
    elsif entity.is_a?(Treat::Entities::Token)
      tag = text.get(:tokens).iterator.next.
      get(:named_entity_tag).to_s.downcase
      entity.set :named_entity_tag, 
      tag.intern unless tag == 'o'
    end

  end

  # Get a Java ArrayList binding to pass lists
  # of tokens to the Stanford Core NLP process.
  def self.get_list(words)
    list = StanfordCoreNLP::ArrayList.new
    words.each do |w|
      list.add(StanfordCoreNLP::Word.new(w.to_s))
    end
    list
  end

end