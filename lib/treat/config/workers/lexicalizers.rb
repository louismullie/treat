{
  taggers: {
    type: :annotator,
    targets: [:phrase, :token]
  },
  categorizers: {
    type: :annotator,
    targets: [:phrase, :token],
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