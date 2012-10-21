{
  readers: {
    type: :computer,
    targets: [:document],
  },
  unserializers: {
    type: :computer,
    targets: [:entity],
  },
  serializers: {
    type: :computer,
    targets: [:entity],
    default: :yaml,
  },
  visualizers: {
    type: :computer,
    targets: [:entity],
    default: :tree
  }
}