# POS tagging using (i) explicit use of both preceding
# and following tag contexts via a dependency network
# representation, (ii) broad use of lexical features,
# including jointly conditioning on multiple consecutive
# words, (iii) effective use of priors in conditional
# loglinear models, and (iv) ﬁne-grained modeling of
# unknown word features.
#
# Original paper: Toutanova, Manning, Klein and Singer.
# 2003. Feature-Rich Part-of-Speech Tagging with a
# Cyclic Dependency Network. In Proceedings of the
# Conference of the North American Chapter of the
# Association for Computational Linguistics.
class Treat::Workers::Lexicalizers::Taggers::Stanford

  # Hold one tagger per language.
  @@taggers = {}

  # Hold the default options.
  DefaultOptions =  {
    :tagger_model => nil
  }

  # Shortcut for gem config.
  Config = StanfordCoreNLP::Config

  # Tag the word using one of the Stanford taggers.
  def self.tag(entity, options = {})

    # Handle tags for sentences and phrases.
    if entity.is_a?(Treat::Entities::Group) &&
      !entity.parent_sentence

      tag_set = options[:tag_set]
      entity.set :tag_set, tag_set
    end

    return 'S' if entity.is_a?(Treat::Entities::Sentence)
    return 'P' if entity.is_a?(Treat::Entities::Phrase)
    return 'F' if entity.is_a?(Treat::Entities::Fragment)
    return 'G' if entity.is_a?(Treat::Entities::Group)

    # Handle options and initialize the tagger.
    lang = entity.language.intern
    init_tagger(lang) unless @@taggers[lang]
    options = get_options(options, lang)
    tokens, t_list = get_token_list(entity)

    # Do the tagging.
    i = 0
    isolated_token = entity.is_a?(Treat::Entities::Token)

    @@taggers[lang].apply(t_list).each do |tok|
      tokens[i].set(:tag, tok.tag)
      tokens[i].set(:tag_set,
      options[:tag_set]) if isolated_token
      return tok.tag if isolated_token
      i += 1
    end

  end

  # Initialize the tagger for a language.
  def self.init_tagger(language)
    unless @@taggers[language]
      Treat::Loaders::Stanford.load(language)
      model = Treat::Loaders::Stanford.find_model(:pos,language)
      tagger = StanfordCoreNLP::MaxentTagger.new(model)
      @@taggers[language] = tagger
    end
    @@taggers[language]
  end

  # Handle the options for the tagger.
  def self.get_options(options, language)
    options = DefaultOptions.merge(options)
    if options[:tagger_model]
      StanfordCoreNLP.set_model('pos.model',
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
