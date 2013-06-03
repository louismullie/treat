{
  acronyms: 
    ['xml', 'html', 'txt', 'odt',
    'abw', 'doc', 'yaml', 'uea',
    'lda', 'pdf', 'ptb', 'dot',
    'ai', 'id3', 'svo', 'mlp',
    'svm', 'srx', 'nlp'],
  
  encodings: 
    {language_to_code: {
      arabic: 'UTF-8',
      chinese: 'GB18030',
      english: 'UTF-8',
      french: 'ISO_8859-1',
      ferman: 'ISO_8859-1',
      hebrew: 'UTF-8'
  }},

  entities: 
      {list: 
        [:entity, :unknown, :email, 
         :url, :symbol, :sentence, 
         :punctuation, :number, 
         :enclitic, :word, :token, :group,
         :fragment, :phrase, :paragraph, 
         :title, :zone, :list, :block, 
         :page, :section, :collection, 
         :document],
      order: 
        [:token, :fragment, :group, 
         :sentence, :zone, :section, 
         :document, :collection]},
      language: {
        default: :english, 
        detect: false, 
        detect_at: :document
      },
      paths: {
        description: {
          tmp: 'temporary files',
          lib: 'class and module definitions',
          bin: 'binary files',
          files: 'user-saved files',
          models: 'model files',
          spec: 'spec test files'
        }
      },
  learning: {
    list: [:data_set, :export, :feature, :tag, :problem, :question]
  },
  syntax: { sweetened: false },

  verbosity: { debug: false, silence: true}
}