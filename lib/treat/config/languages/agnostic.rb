{
  dependencies: [
    'whatlanguage', 
    'psych', 
    'mongo', 
    'bson_ext', 
    'linguistics'
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