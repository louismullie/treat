{
  dependencies: [
    'nokogiri', 'ferret',
    'bson_ext', 'mongo', 'lda-ruby',
    'stanford-core-nlp', 'linguistics',
    'jruby-readability', 'whatlanguage',
    'chronic', 'nickel', 'decisiontree',
    'rb-libsvm', 'ruby-fann', 'zip',
    'tf-idf-similarity', 'narray', 'fastimage'
  ],
  workers: {
    learners: {
      classifiers: [:id3, :linear, :mlp, :svm]
    },
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
    },
    retrievers: {
      searchers: [:ferret],
      indexers: [:ferret]
    }
  }
}