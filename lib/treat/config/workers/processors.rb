{
  chunkers: {
    type: :transformer,
    targets: [:document],
    default: :autoselect
  },
  segmenters: {
    type: :transformer,
    targets: [:zone]
  },
  tokenizers: {
    type: :transformer,
    targets: [:sentence, :phrase]
  },
  parsers: {
    type: :transformer,
    targets: [:sentence, :phrase] 
  }
}