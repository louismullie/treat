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
    targets: [:group]
  },
  parsers: {
    type: :transformer,
    targets: [:group] 
  }
}