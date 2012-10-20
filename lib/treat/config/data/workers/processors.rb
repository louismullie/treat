{
  chunkers: {
    type: :transformer,
    targets: [:document, :section],
    default: :autoselect
  },
  segmenters: {
    type: :transformer,
    targets: [:zone]
  },
  tokenizers: {
    type: :transformer,
    targets: [:group]
  },
  parsers: {
    type: :transformer,
    targets: [:group] 
  }
}