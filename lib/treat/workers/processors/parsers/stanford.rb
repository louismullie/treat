# Parsing using an interface to a Java implementation
# of probabilistic natural language parsers, both
# optimized PCFG and lexicalized dependency parsers,
# and a lexicalized PCFG parser.
#
# Original paper: Dan Klein and Christopher D.
# Manning. 2003. Accurate Unlexicalized Parsing.
# Proceedings of the 41st Meeting of the Association
# for Computational Linguistics, pp. 423-430.
class Treat::Workers::Processors::Parsers::Stanford

  Pttc = Treat.tags.aligned.phrase_tags_to_category

  # Hold one instance of the pipeline per language.
  @@parsers = {}

  DefaultOptions = { model: nil }

  # Parse the entity using the Stanford parser.
  def self.parse(entity, options = {})

    val, lang = entity.to_s, entity.language.intern

    Treat::Loaders::Stanford.load(lang)
    
    tag_set = StanfordCoreNLP::Config::TagSets[lang]
    
    list = get_token_list(entity)

    model_file     = options[:model] || 
    StanfordCoreNLP::Config::Models[:parse][lang]
    
    unless @@parsers[lang] && @@parsers[lang][model_file]
      model_path   = Treat.libraries.stanford.model_path ||
                     StanfordCoreNLP.model_path
      model_folder = StanfordCoreNLP::Config::ModelFolders[:parse]
      model = File.join(model_path, model_folder, model_file)
      @@parsers[lang] ||= {}
      options = StanfordCoreNLP::Options.new
      parser = StanfordCoreNLP::LexicalizedParser
      .getParserFromFile(model, options)
      @@parsers[lang][model_file] = parser
    end
    
    parser = @@parsers[lang][model_file]
    
    text = parser.apply(list)
    recurse(text, entity, tag_set)
    entity.set :tag_set, tag_set

  end

  def self.recurse(java_node, ruby_node, tag_set)
    
    java_node.children.each do |java_child|

      label = java_child.label
      tag = label.get(:category).to_s

      if Pttc[tag] && Pttc[tag][tag_set]
        ruby_child = Treat::Entities::Phrase.new
        ruby_child.set :tag, tag
        ruby_node << ruby_child
        unless java_child.children.empty?
          recurse(java_child, ruby_child, tag_set)
        end
      else
        val = java_child.children[0].to_s
        ruby_child = Treat::Entities::Token.from_string(val)
        ruby_child.set :tag, tag
        ruby_node << ruby_child
      end
      
    end

  end

  def self.get_token_list(entity)
    list = StanfordCoreNLP::ArrayList.new
    entity.tokens.each do |token|
      list.add(StanfordCoreNLP::Word.new(token.to_s))
    end
    list
  end

end
