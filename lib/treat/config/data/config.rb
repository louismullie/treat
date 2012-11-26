{acronyms: 
  ['xml', 'html', 'txt', 'odt',
  'abw', 'doc', 'yaml', 'uea',
  'lda', 'pdf', 'ptb', 'dot',
  'ai', 'id3', 'svo', 'mlp',
  'svm', 'srx'],
  
encodings: 
  {language_to_code: {
    arabic: 'UTF-8',
    chinese: 'GB18030',
    english: 'UTF-8',
    french: 'UTF-8',
    german: 'UTF-8',
    hebrew: 'UTF-8'
}},

entities: 
    {list: 
      [:entity, :unknown, :email, 
       :url, :symbol, :sentence, 
       :punctuation, :number, 
       :enclitic, :word, :token, 
       :fragment, :phrase, :paragraph, 
       :title, :zone, :list, :block, 
       :page, :section, :collection, 
       :document],
    order: 
      [:token, :fragment, :phrase, 
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
    
syntax: { sweetened: false },

verbosity: { debug: false, silence: true}}