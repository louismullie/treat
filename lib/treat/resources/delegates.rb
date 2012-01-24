module Treat
  module Resources
    module Delegates
      class English
        Extractors = {
          time: [:chronic],
          topics: [:reuters],
          topic_words: [:lda],
          key_sentences: [:topics_frequency]
        }
        Processors = {
          chunkers: [:txt],
          parsers: [:enju, :stanford],
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
          conjugators: [:linguistics],
          declensors: [:linguistics, :english],
          lemmatizers: [:e_lemma],
          stemmers: [:porter_c, :porter, :uea],
          ordinal_words: [:linguistics],
          cardinal_words: [:linguistics]
        }
      end
      class German
        Extractors = {}
        Inflectors = {}
        Lexicalizers = {
          tag: [:stanford]
        }
        Processors = {
          chunkers: [:txt],
          parsers: [:stanford],
          segmenters: [:tactful, :punkt, :stanford],
          tokenizers: [:multilingual, :macintyre, :perl, :punkt, :tactful, :stanford]
        }
      end
      class French
        Extractors = {}
        Inflectors = {}
        Lexicalizers = {
          tag: [:stanford]
        }
        Processors = {
          chunkers: [:txt],
          parsers: [:stanford],
          segmenters: [:tactful, :punkt, :stanford],
          tokenizers: [:multilingual, :macintyre, :perl, :punkt, :tactful, :stanford]
        }
      end
      class Italian
        Extractors = {}
        Inflectors = {}
        Lexicalizers = {}
        Processors = {
          chunkers: [:txt],
          segmenters: [:tactful, :punkt, :stanford],
          tokenizers: [:multilingual, :macintyre, :perl, :punkt, :tactful, :stanford]
        }
      end
      class Arabic
        Extractors = {}
        Inflectors = {}
        Lexicalizers = {
          tag: [:stanford]
        }
        Processors = {
          parsers: [:stanford]
        }
      end
      class Chinese
        Extractors = {}
        Inflectors = {}
        Lexicalizers = {
          tag: [:stanford]
        }
        Processors = {}
      end
      class Xinhua
        Extractors = {}
        Inflectors = {}
        Lexicalizers = {}
        Processors = {
          parsers: [:stanford]
        }
      end
    end
  end
end
