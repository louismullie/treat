{
  dependencies: [
    'psych',
    'nokogiri',
    'ferret',
    'bson_ext',
    'mongo',
    'lda-ruby',
    'stanford-core-nlp',
    'linguistics',
    'ruby-readability',
    'whatlanguage',
    'chronic',
    'nickel',
    'decisiontree',
    'rb-libsvm',
    'ai4r',
    'zip'
  ],
  workers: {
    extractors: {
      keywords: [:tf_idf],
      language: [:what_language],
      topic_words: [:lda],
      tf_idf: [:native]
    },
    formatters: {
      serializers: [:xml, :yaml, :mongo],
      unserializers: [:xml, :yaml, :mongo],
      visualizers: [:dot, :standoff, :tree]
      
    }
  }
}