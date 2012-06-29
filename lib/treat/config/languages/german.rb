{
  dependencies: [
    'punkt-segmenter', 
    'tactful_tokenizer', 
    'stanford'
  ],
  workers: {
    processors: {
      segmenters: [:punkt],
      tokenizers: [:tactful],
      parsers: [:stanford]
    },
    lexicalizers: {
      taggers: [:stanford],
      categorizers: [:from_tag]
    }
  }
}