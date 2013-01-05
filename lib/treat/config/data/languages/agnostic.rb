{
  dependencies: [
    'nokogiri', 'ferret',
    'bson_ext', 'mongo', 'lda-ruby',
    'stanford-core-nlp', 'linguistics',
    'ruby-readability', 'whatlanguage',
    'chronic', 'nickel', 'decisiontree',
    'rb-libsvm', 'ruby-fann', 'zip', 'loggability',
    'tf-idf-similarity', 'narray', 'fastimage',
    'fuzzy-string-match', 'levenshtein-ffi'
  ],
  workers: {
    learners: {
      classifiers: [:id3, :linear, :mlp, :svm]
    },
    extractors: {
      keywords: [:tf_idf],
      language: [:what_language],
      topic_words: [:lda],
      tf_idf: [:native],
      distance: [:levenshtein],
      similarity: [:jaro_winkler, :tf_idf]
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