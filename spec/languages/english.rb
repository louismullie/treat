class Treat::Spec::Languages::English < Treat::Spec::Languages::Benchmark
  
  def initialize
    super(Benchmarks, 'english')
  end

  Benchmarks = {
    tokenize: {
      group: {
        examples: [
          ["A test phrase", ["A", "test", "phrase"]]
        ],
        generator: lambda { |entity| entity.tokens.map { |tok| tok.to_s } }
      }
    },
    parse: {
      group: {
        examples: [
          ["A sentence to tokenize.", ["A sentence to tokenize.", "A sentence", "to tokenize",
"tokenize"]]
        ],
        generator: lambda { |group| group.phrases.map { |phrase| phrase.to_s } }
      }
    },
    segment: {
      zone: {
        examples: [
          ["This is e.g. Mr. Smith, who talks slowly... And this is another sentence. This sentence contains the U.S. abbreviation. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged.", ["This is e.g. Mr. Smith, who talks slowly...", "And this is another sentence.", "This sentence contains the U.S. abbreviation.", "Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.", "It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged."]]
        ],
        generator: lambda { |entity| entity.sentences.map { |sent| sent.to_s } }
      }
    },
    tag: {
      phrase: {
        examples: [
          ["I was running", "P"]
        ]
      },
      token: {
        examples: [
          ["running", "VBG"],
          ["man", "NN"],
          ["2", "CD"],
          [".", "."],
          ["$", "$"]
        ]
      }
    },
    category: {
      phrase: {
        examples: [
          ["I was running", "phrase"]
        ]
      },
      token: {
        examples: [
          ["running", "verb"]
        ]
      }
    },
    ordinal: {
      word: {
        examples: [
          ["20", "twentieth"]
        ]
      },
      number: {
        examples: [
          [20, "twentieth"]
        ]
      }
    },
    cardinal: {
      word: {
        examples: [
          ['20', "twenty"]
        ]
      },
      number: {
        examples: [
          [20, "twenty"]
        ]
      }
    },
    name_tag: {
      group: {
        examples: [
          ["Obama and Sarkozy will meet in Berlin.", ["person", nil, "person", nil, nil, nil, "location"]]
        ],
        preprocessor: lambda { |group| group.tokenize },
        generator: lambda { |group| group.words.map { |word| word.get(:name_tag) } }
      }
    },
    language: { ######
      entity: {
        examples: [
          ["Obama and Sarkozy will meet in Berlin.", "english"]
        ],
        preprocessor: lambda { |entity| Treat.core.language.detect = true; entity.do(:tokenize); entity },
        postprocessor: lambda { |entity| Treat.core.language.detect = false; entity; },
        generator: lambda { |group| group.words.map { |word| word.get(:name_tag) } }
      }
    },
    stem: {
      word: {
        examples: [
          ["running", "run"]
        ]
      }
    },
    time: {
      group: {
        examples: [
          ['october 2006', 10]
        ],
        generator: lambda { |entity| entity.time.month }
      }
    },
    topics: {
      document: {
        examples: [
          ["./spec/languages/english/test.txt", 
          ['household goods and hardware', 
          'united states of america', 
          'corporate/industrial']]
        ],
        preprocessor: lambda { |doc| doc.do :chunk, :segment, :tokenize }
      },
      section: {
        # Must implement
      },
      zone: {
        examples: [
          ["Michigan, Ohio, Texas - Unfortunately, the RadioShack is closing. This is horrible news for U.S. politics.", ['household goods and hardware', 'united states of america', 'corporate/industrial']]
        ],
        preprocessor: lambda { |zone| zone.do :segment, :tokenize }
      }
    },
    topic_words: {
      collection: {
        examples: [
          ["./perf/examples/economist", [""]]
        ],
        preprocessor: lambda { |coll| coll.do :chunk, :segment, :tokenize }
      }
    },
    conjugate: {
      word: {
        examples: {
          present_participle: [
            ["run", "running"]
          ],
          infinitive: [
            ["running", "run"]
          ]
        }
      }
    },
    declense: {
      word: {
        examples: {
          singular: [
            ["men", "man"]
          ],
          plural: [
            ["runs", "run"]
          ]
        }
      }
    },
    sense: {
      word: {
        examples: {
          synonyms: [
            ["throw", ["throw", "shed", "cast", "cast_off", "shake_off", "throw_off", "throw_away", "drop", "thrust", "give", "flip", "switch", "project", "contrive", "bewilder", "bemuse", "discombobulate", "hurl", "hold", "have", "make", "confuse", "fox", "befuddle", "fuddle", "bedevil", "confound"],]
          ],
          antonyms: [
            ["weak", ["strong"]]
          ],
          hypernyms: [
            ["table", ["array", "furniture", "piece_of_furniture", "article_of_furniture", "tableland", "plateau", "gathering", "assemblage", "fare"]]
          ],
          hyponyms: [
            ["furniture", ["baby_bed", "baby's_bed", "bedroom_furniture", "bedstead", "bedframe", "bookcase", "buffet", "counter", "sideboard", "cabinet", "chest_of_drawers", "chest", "bureau", "dresser", "dining-room_furniture", "etagere", "fitment", "hallstand", "lamp", "lawn_furniture", "nest", "office_furniture", "seat", "sectional", "Sheraton", "sleeper", "table", "wall_unit", "wardrobe", "closet", "press", "washstand", "wash-hand_stand"]]
          ]
        }
      }
    },
  }

end