{
  dependencies: [
    'stanford-core-nlp'
  ],
  workers: {
    processors: {
      parsers: [:stanford]
    },
    lexicalizers: {
      taggers: [:stanford]
    }
  }
}