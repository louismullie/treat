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
    'ai4r'
  ],
  workers: {
    extractors: {
      keywords: [:tf_idf],
      language: [:what_language]
    },
    formatters: {
      serializers: [:xml, :yaml, :mongo]
    },
    lexicalizers: {
      categorizers: [:from_tag]
    },
    inflectors: {
      ordinalizers: [:linguistics],
      cardinalizers: [:linguistics]
    }
  }
}