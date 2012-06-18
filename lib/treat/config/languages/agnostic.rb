{
  dependencies: {
    required: [],
    optional: []
  },
  workers: {
    extractors: {
      keywords: [:tf_idf],
      language: [:what_language]
    },
    formatters: {
      serializers: [:xml, :yaml]
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