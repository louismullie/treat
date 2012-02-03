module Treat
  module Languages
    class English
      
      Dir["#{Treat.lib}/treat/languages/english/*.rb"].each { |file| require file }
      
      Extractors = {
        :time => [:nickel, :chronic, :ruby],
        :topics => [:reuters],
        :topic_words => [:lda],
        :keywords => [:tf_idf, :topics_tf_idf],
        :named_entity_tag => [:stanford],
        :coreferences => [:stanford]
      }
      
      Processors = {
        :chunkers => [:txt],
        :parsers => [:stanford, :enju],
        :segmenters => [:tactful, :punkt, :stanford],
        :tokenizers => [:macintyre, :multilingual, :perl, :punkt, :stanford, :tactful]
      }
      
      Lexicalizers = {
        category: [:from_tag],
        linkages: [:naive],
        synsets: [:wordnet],
        tag: [:brill, :lingua, :stanford]
      }
      
      Inflectors = {
        conjugations: [:linguistics],
        declensions: [:english, :linguistics],
        stem: [:porter, :porter_c, :uea],
        ordinal_words: [:linguistics],
        cardinal_words: [:linguistics]
      }
      
    end
  end
end
