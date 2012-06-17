{
  dependencies: {
    required: [],
    optional: []
  },
  workers: {
    extractors: {
      keywords: [:tf_idf],
    },
    formatters: {
      serializers: [:xml, :yaml]
    }
  }
}