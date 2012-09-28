# Named entity tag extraction using the Stanford NLP
# Deterministic Coreference Resolver, which implements a
# multi-pass sieve coreference resolution (or anaphora 
# resolution) system.
#
# Original paper: Heeyoung Lee, Yves Peirsman, Angel 
# Chang, Nathanael Chambers, Mihai Surdeanu, Dan Jurafsky. 
# Stanford's Multi-Pass Sieve Coreference Resolution 
# System at the CoNLL-2011 Shared Task. In Proceedings 
# of the CoNLL-2011 Shared Task, 2011.
class Treat::Workers::Extractors::NameTag::Stanford

  Treat::Loaders::Stanford.load
  
  @@classifiers = {}

  def self.name_tag(entity, options = {})

    pp = nil

    language = entity.language
  
    Treat::Loaders::Stanford.load(language)
    
    isolated_token = entity.is_a?(Treat::Entities::Token)
    tokens = isolated_token ? [entity] : entity.tokens

    ms = StanfordCoreNLP::Config::Models[:ner][language]
    model_path = Treat.libraries.stanford.model_path ||
    (Treat.paths.models + '/stanford/')
    ms = model_path + '/' + 
    StanfordCoreNLP::Config::ModelFolders[:ner] +
    ms['3class']

    @@classifiers[language] ||=
    StanfordCoreNLP::CRFClassifier.
    getClassifier(ms)

    token_list = StanfordCoreNLP.get_list(tokens)
    sentence = @@classifiers[language].
    classify_sentence(token_list)

    i = 0
    n = 0
    
    sentence.each do |s_token|
      tag = s_token.get(:answer).to_s.downcase
      tag = nil if tag == 'o'
      return tag if isolated_token
      if tag
        tokens[i].set :name_tag, tag
        n += 1
      end
      i += 1
    end

    entity.set :named_entity_count, n

    nil
    
  end



end
