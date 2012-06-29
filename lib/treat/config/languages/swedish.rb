{
  dependencies: [
    'punkt-segmenter', 
    'tactful_tokenizer'
  ],
  workers: {
    processors: {
      segmenters: [:punkt],
      tokenizers: [:tactful]
    }
  }
}