class Treat::Languages::English

  RequiredDependencies = ['rbtagger', 'ruby-stemmer', 'tactful_tokenizer', 'nickel', 'rwordnet']
  OptionalDependencies = ['uea-stemmer', 'engtagger', 'active_support', 'english']

  Extractors = {
    :time => [:chronic, :ruby, :nickel],
    :topics => [:reuters],
    :topic_words => [:lda],
    :keywords => [:tf_idf],
    :name_tag => [:stanford],
    :coreferences => [:stanford],
    :roles => [:naive]
  }
  
  Inflectors = {
    :conjugators => [:linguistics],
    :declensors => [:english, :linguistics, :active_support],
    :stemmers => [:porter, :porter_c, :uea],
    :ordinalizers => [:linguistics],
    :cardinalizers => [:linguistics]
  }
  
  Lexicalizers = {
    :categorizers => [:from_tag],
    :taggers => [:lingua, :brill, :stanford],
    :sensers => [:wordnet]
  }

  Processors = {
    :chunkers => [:txt],
    :parsers => [:stanford, :enju],
    :segmenters => [:tactful, :punkt, :stanford],
    :tokenizers => [:ptb, :stanford, :tactful, :punkt]
  }
  
  Retrievers = {
    :searchers => [:ferret],
    :indexers => [:ferret]
  }

  CommonWords = [
    'the', 'of', 'and', 'a', 'to', 'in', 'is',
    'you', 'that', 'it', 'he', 'was', 'for', 'on',
    'are', 'as', 'with', 'his', 'they', 'I', 'at',
    'be', 'this', 'have', 'from', 'or', 'one', 'had',
    'by', 'word', 'but', 'not', 'what', 'all', 'were',
    'we', 'when', 'your', 'can', 'said', 'there', 'use',
    'an', 'each', 'which', 'she', 'do', 'how', 'their',
    'if', 'will', 'up', 'other', 'about', 'out', 'many',
    'then', 'them', 'these', 'so', 'some', 'her', 'would',
    'make', 'like', 'him', 'into', 'time', 'has', 'look',
    'two', 'more', 'write', 'go', 'see', 'number', 'no',
    'way', 'could', 'people', 'my', 'than', 'first', 'been',
    'call', 'who', 'its', 'now', 'find', 'long', 'down',
    'day', 'did', 'get', 'come', 'made', 'may', 'part',
    'say', 'also', 'new', 'much', 'should', 'still',
    'such', 'before', 'after', 'other', 'then', 'over',
    'under', 'therefore', 'nonetheless', 'thereafter',
    'afterwards', 'here', 'huh', 'hah', "n't", "'t", 'here'
  ]
  
end
