# Wrapper for the Stanford POS tagger.
class Treat::Lexicalizers::Tag::Stanford

  require 'treat/loaders/stanford'
  Treat::Loaders::Stanford.load
  StanfordCoreNLP.load_class('ArrayList', 'java.util')
  StanfordCoreNLP.load_class('Word', 'edu.stanford.nlp.ling')
  StanfordCoreNLP.load_class('MaxentTagger', 'edu.stanford.nlp.tagger.maxent')

  # Hold one tagger per language.
  @@taggers = {}
  
  # Hold the default options.
  DefaultOptions =  {
    :tagger_model => nil,
    :silent => false
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
    init_tagger(lang, options[:silent])
    
    # Do the tagging.
    i = 0
    @@taggers[lang].apply(list).each do |tok|
      tokens[i].set :tag_set, options[:tag_set]
      tokens[i].set :tag, tok.tag
      return tok.tag if tokens.size == 1
      i += 1
    end

    # Handle tags for sentences and phrases.
    entity.set :tag_set, options[:tag_set]
    if entity.is_a?(Treat::Entities::Sentence)
      return 'S'
    elsif entity.is_a?(Treat::Entities::Phrase)
      return 'P'
    end

  end
  
  # Initialize the tagger for a language.
  def self.init_tagger(lang, silence)
    
    language = Treat::Languages.describe(lang)
    model = StanfordCoreNLP::Config::Models[:pos][language]
    model = Treat.data + 'stanford/' +
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
    options[:log_file] =
    '/dev/null' if options[:silence]
    if options[:log_file]
      ::StanfordCoreNLP.log_file =
      options[:log_file]
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