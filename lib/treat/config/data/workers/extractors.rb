{
  language: {
    type: :annotator,
    targets: [:entity],
    default: :what_language
  },
  time: {
    type: :annotator,
    targets: [:group]
  },
  topics: {
    type: :annotator,
    targets: [:document, :section, :zone]
  },
  keywords: {
    type: :annotator,
    targets: [:document, :section, :zone]
  },
  topic_words: {
    type: :annotator,
    targets: [:collection]
  },
  name_tag: {
    type: :annotator,
    targets: [:group]
  },
  tf_idf: {
    type: :annotator,
    targets: [:word]
  },
  similarity: {
    type: :computer,
    targets: [:entity]
  },
  distance: {
    type: :computer,
    targets: [:entity]
  }
}
