{
  language: {
    type: :annotator,
    targets: [:entity],
    default: :what_language
  },
  time: {
    type: :annotator,
    targets: [:phrase]
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
    targets: [:phrase, :word]
  },
  coreferences: {
    type: :annotator,
    targets: [:zone]
  },
  tf_idf: {
    type: :annotator,
    targets: [:word]
  },
  summary: {
    type: :annotator,
    targets: [:document]
  }
}
