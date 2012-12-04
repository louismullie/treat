{
  taggers: {
    type: :annotator,
    targets: [:group, :token],
    recursive: true
  },
  categorizers: {
    type: :annotator,
    targets: [:group, :token],
    recursive: true
  },
  sensers: {
    type: :annotator,
    targets: [:word],
    preset_option: :nym,
    presets: [:synonyms, :antonyms, 
              :hyponyms, :hypernyms],
  }
}