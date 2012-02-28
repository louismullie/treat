# Wrapper for the Stanford POS tagger.
class Treat::Lexicalizers::Tag::Stanford

  require 'treat/loaders/stanford'
  Treat::Loaders::Stanford.load

  # Hold one tagger per language.
  @@taggers = {}
  
  # Hold the default options.
  DefaultOptions =  {
    :tagger_model => nil
  }

  # Tag the word using one of the Stanford taggers.
  def self.tag(entity, options = {})
    
    # Tokenize the sentence/phrase.
    if !entity.has_children? &&
      !entity.is_a?(Treat::Entities::Token)
      entity.tokenize(:stanford, options)
    end
    
    # Handle options and initialize the tagger.
    lang = entity.language
    options = get_options(options, lang)
    tokens, list = get_token_list(entity)
    init_tagger(lang)
    
    # Do the tagging.
    i = 0
    isolated_token = tokens.size == 1
    @@taggers[lang].apply(list).each do |tok|
      tokens[i].set :tag, tok.tag
      tokens[i].set :tag_set, 
      options[:tag_set] if isolated_token
      return tok.tag if isolated_token
      i += 1
    end

    # Handle tags for sentences and phrases.
    
    if entity.is_a?(Treat::Entities::Sentence) ||
      (entity.is_a?(Treat::Entities::Phrase) && 
      !entity.parent_sentence)
        entity.set :tag_set, :penn
    end
    
    if entity.is_a?(Treat::Entities::Sentence)
      return 'S'
    elsif entity.is_a?(Treat::Entities::Phrase)
      return 'P'
    end

  end
  
  # Initialize the tagger for a language.
  def self.init_tagger(lang)
    
    language = Treat::Languages.describe(lang)
    model = StanfordCoreNLP::Config::Models[:pos][language]
    model = Treat.models + 'stanford/' +
    StanfordCoreNLP::Config::ModelFolders[:pos] + model
    @@taggers[lang] ||= 
    StanfordCoreNLP::MaxentTagger.new(model)
    
  end
  
  # Handle the options for the tagger.
  def self.get_options(options, lang)
    language = Treat::Languages.describe(lang)
    options = DefaultOptions.merge(options)
    options[:tag_set] = 
    StanfordCoreNLP::Config::TagSets[language]
    if options[:tagger_model]
      ::StanfordCoreNLP.set_model('pos.model',
      options[:tagger_model])
    end
    options[:tag_set] = 
    StanfordCoreNLP::Config::TagSets[language]
    options
  end
  
  # Retrieve a Java ArrayList object.
  def self.get_token_list(entity)
    list = StanfordCoreNLP::ArrayList.new
    if entity.is_a?(Treat::Entities::Token)
      tokens = [entity]
    else
      tokens = entity.tokens
    end
    tokens.each do |token|
      list.add(StanfordCoreNLP::Word.new(token.to_s))
    end
    return tokens, list
  end
  
end