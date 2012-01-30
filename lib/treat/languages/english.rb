module Treat
  module Languages
    class English
      
      require 'treat/languages/english/tags'
      require 'treat/languages/english/categories'
      
      Extractors = {
        time: [:nickel, :chronic, :ruby],
        topics: [:reuters],
        topic_words: [:lda],
        keywords: [:topics_frequency],
        named_entity: [:stanford]
      }
      Processors = {
        chunkers: [:txt],
        parsers: [:stanford, :enju],
        segmenters: [:tactful, :punkt, :stanford],
        tokenizers: [:tactful, :macintyre, :multilingual, :perl, :punkt, :stanford]
      }
      Lexicalizers = {
        category: [:from_tag],
        linkages: [:naive],
        synsets: [:wordnet, :rita_wn],
        tag: [:brill, :lingua, :stanford]
      }
      Inflectors = {
        conjugations: [:linguistics],
        declensions: [:english, :linguistics],
        stem: [:porter_c, :porter, :uea],
        ordinal_words: [:linguistics],
        cardinal_words: [:linguistics]
      }
      
    end
  end
end
