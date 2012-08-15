{
  stemmers: {
    type: :annotator,
    targets: [:word]
  },
  declensors: {
    type: :annotator,
    targets: [:word],
    preset_option: :count,
    presets: [:plural, :singular]
  },
  conjugators: {
    type: :annotator,
    targets: [:word],
    preset_option: :form,
    presets: [:infinitive, :present_participle, 
              :plural_verb, :singular_verb]
  },
  cardinalizers: {
    type: :annotator,
    targets: [:word, :number]
  },
  ordinalizers: {
    type: :annotator,
    targets: [:word, :number]
  }
}