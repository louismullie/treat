{
  indexers: {
    type: :annotator,
    targets: [:collection],
    default: :ferret
  },
  searchers: {
    type: :computer,
    targets: [:collection],
    default: :ferret
  }
}