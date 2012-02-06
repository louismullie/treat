module Treat
  module Languages
    class English
      
      RequiredDependencies = ['rbtagger', 'ruby-stemmer', 'tactful_tokenizer', 'nickel', 'wordnet']
      OptionalDependencies = ['uea-stemmer', 'tokenizer', 'engtagger']
      
      Extractors = {
        :time => [:nickel],
        :date => [:chronic, :ruby],
        :topics => [:reuters],
        :topic_words => [:lda],
        :keywords => [:tf_idf, :topics_tf_idf],
        :named_entity_tag => [:stanford],
        :coreferences => [:stanford],
        :roles => [:naive]
      }
      
      Processors = {
        :chunkers => [:txt],
        :parsers => [:stanford, :enju],
        :segmenters => [:tactful, :punkt, :stanford],
        :tokenizers => [:macintyre, :multilingual, :perl, :punkt, :stanford, :tactful]
      }
      
      Lexicalizers = {
        :category => [:from_tag],
        :linkages => [:naive],
        :synsets => [:wordnet],
        :tag => [:brill, :lingua, :stanford]
      }
      
      Inflectors = {
        :conjugations => [:linguistics],
        :declensions => [:english, :linguistics],
        :stem => [:porter, :porter_c, :uea],
        :ordinal_words => [:linguistics],
        :cardinal_words => [:linguistics]
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
        'afterwards', 'here', 'huh', 'hah', "'nt", "'t", 'here'
      ]
      
    end
  end
end
