class Treat::Specs::Workers::Agnostic < Treat::Specs::Workers::Language

  # TODO: :tf_idf, :keywords, :classifiers
  # :read,. :unserialize

  Scenarios = {

    # Also tests unserialize.
    serialize: {
      entity: {
        examples: [
          ["A test entity.", "A test entity."]
        ],
        generator: lambda { |selector| Treat::Entities::Entity.buikd(selector).to_s }
      }
    },
    classify: {
      entity: {
        examples: [
          ["Homer", 1, lambda { {training: Treat::Learning::DataSet.build('test.marshal')} }]
        ],
        preprocessor: lambda do |entity|
          ds = Treat::Learning::DataSet.new(
          Treat::Learning::Problem.new(
            Treat::Learning::Question.new(:is_person, :word, :discrete, :false, [0, 1]), 
            Treat::Learning::Feature.new(:first_capital, 0, "->(e) {  (e.to_s[0] =~ /^[A-Z]$/) ? 1 : 0 }"), 
            Treat::Learning::Tag.new(:value, 0)
          ))
          w1, w2, w3, w4, w5 = 
          ["Alfred", "lucky", "Hobbit", "hello", "Alice"].
          map { |w| Treat::Entities::Word.new(w) }
          w1.set :is_person, 1
          w2.set :is_person, 0
          w3.set :is_person, 1
          w4.set :is_person, 0
          w5.set :is_person, 1
          ds << w1; ds << w2; ds << w3
          ds.serialize :marshal, file: 'test.marshal'
        end
      }
    },
    visualize: {
      entity: {
        examples: {
          standoff: [
            ["I walked to the store.", "(S\n   (PRP I)   (VBD walked)   (TO to)   (DT the)   (NN store)   (. .))\n"]
          ],
          tree: [
            ["I walked to the store.", "+ Sentence (*)  --- \"I walked to the store.\"  ---  {}   --- [] \n|\n+--> Word (*)  --- \"I\"  ---  {}   --- [] \n+--> Word (*)  --- \"walked\"  ---  {}   --- [] \n+--> Word (*)  --- \"to\"  ---  {}   --- [] \n+--> Word (*)  --- \"the\"  ---  {}   --- [] \n+--> Word (*)  --- \"store\"  ---  {}   --- [] \n+--> Punctuation (*)  --- \".\"  ---  {}   --- [] "]
          ],
          dot: [
            ["I walked to the store.", "graph {\n* [label=\"Sentence\\n\\\"I walked to the store.\\\"\",color=\"\"]\n* [label=\"Word\\n\\\"I\\\"\",color=\"\"]\n* -- *;\n* [label=\"Word\\n\\\"walked\\\"\",color=\"\"]\n* -- *;\n* [label=\"Word\\n\\\"to\\\"\",color=\"\"]\n* -- *;\n* [label=\"Word\\n\\\"the\\\"\",color=\"\"]\n* -- *;\n* [label=\"Word\\n\\\"store\\\"\",color=\"\"]\n* -- *;\n* [label=\"Punctuation\\n\\\".\\\"\",color=\"\"]\n* -- *;\n}"]
          ]
        },
        preprocessor: lambda  { |entity| entity.tokenize },
        generator: lambda  { |result| result.gsub(/[0-9]+/, '*') }
      }
    },

    keywords: {
      document: {
        examples: [
          ["./spec/workers/examples/english/economist/saving_the_euro.odt",
            ["crisis", "government", "called", "financial", "funds", "treaty"]]
          ],
          preprocessor: lambda do |document|
            coll = Treat::Entities::Collection.build('./spec/workers/examples/english/economist/')
            coll << document
            coll.apply(:chunk, :segment, :tokenize, :keywords)
            document
          end
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
      },
=begin  
    unserialize: {
      examples: [
        ["A test entity.", "A test entity."]
      ],
      generator: lambda { |selector| Treat::Entities::Entity.build(selector).to_s }
    },
=end
=begin
      # Index
      search: {
        collection: {
          examples: [
            ["./spec/workers/examples/english/economist/", 
              "Hungary's troubles", {query: 'Hungary'}]
          ],
          generator: lambda { |docs| docs[0].titles[0] },
          preprocessor: lambda { |coll| coll.apply(:index) }
      },
    },
=end
=begin
    keywords: {
      document: {
        examples: [
          ["./spec/languages/english/economist/saving_the_euro.odt", 
            ["A", "test", "phrase"]]
        ],
        preprocessor: lambda { |doc| doc.parent = Collection('./spec/languages/english/economist/') }
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
    },
=end
    topic_words: {
      collection: {
        examples: [
          ["./spec/workers/examples/english/economist", [["orban", "minister", "bajnai", "mr", "government", "president", "law", "brussels", "commission", "hu"], ["government", "minister", "fidesz", "mr", "hvg", "today", "hungarian", "bajnai", "national", "office"], ["mr", "today", "central", "minister", "crisis", "prime", "president", "bank", "european", "government"], ["sarkozy", "mr", "greece", "german", "summit", "france", "merkel", "opera", "growth", "euro"], ["central", "hand", "minister", "week", "bank", "forced", "hungarian", "parliament", "political", "hvg"], ["minister", "crisis", "central", "bank", "hand", "law", "forced", "bajnai", "parliament", "president"], ["mr", "bank", "european", "central", "government", "called", "today", "financial", "policies", "press"], ["mr", "crisis", "government", "central", "today", "funds", "president", "issues", "bank", "called"], ["mr", "crisis", "minister", "today", "european", "prime", "financial", "president", "issues", "treaty"], ["central", "minister", "mr", "bajnai", "orban", "bank", "parliament", "week", "fidesz", "washington"], ["mr", "central", "government", "crisis", "minister", "orban", "hand", "fidesz", "bajnai", "judicial"], ["mr", "sarkozy", "chancellor", "government", "european", "merkozy", "role", "mrs", "interest", "quickly"], ["mr", "orban", "government", "crisis", "hungarian", "independence", "prime", "today", "hand", "bajnai"], ["euro", "fiscal", "merkel", "mrs", "sarkozy", "mr", "european", "zone", "leaders", "chancellor"], ["mr", "bank", "crisis", "financial", "president", "funds", "government", "treaty", "central", "part"], ["mr", "central", "minister", "crisis", "prime", "european", "government", "bank", "treaty", "issues"], ["sarkozy", "fiscal", "merkel", "mrs", "growth", "zone", "german", "role", "paper", "quickly"], ["mr", "government", "orban", "bank", "bajnai", "hungarian", "prime", "-", "hu", "commission"], ["mr", "orban", "today", "bank", "minister", "national", "government", "-", "crisis", "forced"], ["role", "summit", "merkel", "euro", "zone", "german", "mr", "greece", "sarkozy", "step"]]]
        ]
      }
    }
  }

end
