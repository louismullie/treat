class Treat::Spec::Languages::Agnostic < Treat::Spec::Languages::Benchmark
  
  # TODO: :keywords, :tf_idf, 
  # :read, :visualize, :serialize, 
  # :unserialize, :search,
  # :index, :classify, 
  # DONE: topic_words

  def initialize
    super(Benchmarks, 'agnostic')
  end
  
  Benchmarks = {
    serialize: {
      entity: {
        examples: [
          ["A test entity", "A test entity."]
        ]
      },
      generator: lambda { |entity| Entity(entity.id + '.' + entity.format) }
    },
    keywords: {
      document: {
        examples: [
          ["./spec/languages/english/economist/saving_the_euro.odt", ["A", "test", "phrase"]]
        ],
        preprocessor: lambda { |document| document.parent = Collection('./spec/languages/english/economist/') }
      },
      section: {
        examples: [
          ["A test phrase", ["A", "test", "phrase"]]
        ]
      },
      zone: {
        examples: [
          ["A test phrase", ["A", "test", "phrase"]]
        ]
      }
    },  ## FIXME
    topic_words: {
      collection: {
        examples: [
          ["./spec/languages/english/economist", [["orban", "minister", "bajnai", "mr", "government", "president", "law", "brussels", "commission", "hu"], ["government", "minister", "fidesz", "mr", "hvg", "today", "hungarian", "bajnai", "national", "office"], ["mr", "today", "central", "minister", "crisis", "prime", "president", "bank", "european", "government"], ["sarkozy", "mr", "greece", "german", "summit", "france", "merkel", "opera", "growth", "euro"], ["central", "hand", "minister", "week", "bank", "forced", "hungarian", "parliament", "political", "hvg"], ["minister", "crisis", "central", "bank", "hand", "law", "forced", "bajnai", "parliament", "president"], ["mr", "bank", "european", "central", "government", "called", "today", "financial", "policies", "press"], ["mr", "crisis", "government", "central", "today", "funds", "president", "issues", "bank", "called"], ["mr", "crisis", "minister", "today", "european", "prime", "financial", "president", "issues", "treaty"], ["central", "minister", "mr", "bajnai", "orban", "bank", "parliament", "week", "fidesz", "washington"], ["mr", "central", "government", "crisis", "minister", "orban", "hand", "fidesz", "bajnai", "judicial"], ["mr", "sarkozy", "chancellor", "government", "european", "merkozy", "role", "mrs", "interest", "quickly"], ["mr", "orban", "government", "crisis", "hungarian", "independence", "prime", "today", "hand", "bajnai"], ["euro", "fiscal", "merkel", "mrs", "sarkozy", "mr", "european", "zone", "leaders", "chancellor"], ["mr", "bank", "crisis", "financial", "president", "funds", "government", "treaty", "central", "part"], ["mr", "central", "minister", "crisis", "prime", "european", "government", "bank", "treaty", "issues"], ["sarkozy", "fiscal", "merkel", "mrs", "growth", "zone", "german", "role", "paper", "quickly"], ["mr", "government", "orban", "bank", "bajnai", "hungarian", "prime", "-", "hu", "commission"], ["mr", "orban", "today", "bank", "minister", "national", "government", "-", "crisis", "forced"], ["role", "summit", "merkel", "euro", "zone", "german", "mr", "greece", "sarkozy", "step"]]]
        ]
      }
    }
  }

end