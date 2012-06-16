{
  taggers: {
    type: :annotator,
    targets: [:sentence, :phrase, :token]
  },
  categorizers: {
    type: :annotator,
    targets: [:sentence, :phrase, :token],
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