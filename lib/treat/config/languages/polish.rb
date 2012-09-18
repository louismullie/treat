{
  dependencies: [
    'punkt-segmenter',
    'srx-polish'
  ],
  workers: {
    processors: {
      segmenters: [:srx, :punkt]
    }
  }
}