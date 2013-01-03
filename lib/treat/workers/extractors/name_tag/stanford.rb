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

    language = entity.language
    Treat::Loaders::Stanford.load(language)
    
    isolated_token = entity.is_a?(Treat::Entities::Token)
    tokens = isolated_token ? [entity] : entity.tokens
    
    unless classifier = @@classifiers[language]
      model = Treat::Loaders::Stanford.find_model(:ner, language)
      classifier = StanfordCoreNLP::CRFClassifier.getClassifier(model)
      @@classifiers[language] = classifier
    end
    
    token_list = StanfordCoreNLP.get_list(tokens)
    sentence = classifier.classify_sentence(token_list)
    i = 0
    
    sentence.each do |s_token|
      tag = s_token.get(:answer).to_s.downcase
      tag = nil if tag == 'o'
      return tag if isolated_token
      if tag
        tokens[i].set :name_tag, tag
      end
      i += 1
    end
    
  end



end
