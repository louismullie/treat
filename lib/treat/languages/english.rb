module Treat
  module Languages
    class English
      
      require 'treat/languages/english/tags'
      require 'treat/languages/english/categories'
      
      Extractors = {
        time: [:chronic],
        topics: [:reuters],
        topic_words: [:lda],
        key_sentences: [:topics_frequency]
      }
      Processors = {
        chunkers: [:txt],
        parsers: [:stanford, :enju],
        segmenters: [:tactful, :punkt, :stanford],
        tokenizers: [:multilingual, :macintyre, :perl, :punkt, :tactful, :stanford]
      }
      Lexicalizers = {
        category: [:from_tag],
        linkages: [:naive],
        synsets: [:wordnet, :rita_wn],
        tag: [:brill, :lingua, :stanford]
      }
      Inflectors = {
        conjugations: [:linguistics],
        declensions: [:linguistics, :english],
        stem: [:porter_c, :porter, :uea],
        ordinal_words: [:linguistics],
        cardinal_words: [:linguistics]
      }
      
    end
  end
end
