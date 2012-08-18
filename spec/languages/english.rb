class Treat::Spec::Languages::English < Treat::Spec::Languages::Benchmark

  # TODO:
  # Enju
  def initialize
    super(Benchmarks, 'english')
  end

  Benchmarks = {
    tokenize: {
      group: {
        examples: [
          ["Julius Obsequens was a Roman writer who is believed to have lived in the middle of the fourth century AD.",      ["Julius", "Obsequens", "was", "a", "Roman", "writer", "who", "is", "believed", "to", "have", "lived", "in", "the", "middle", "of", "the", "fourth", "century", "AD", "."]],
          ["The only work associated with his name is the Liber de prodigiis (Book of Prodigies), completely extracted from an epitome, or abridgment, written by Livy; De prodigiis was constructed as an account of the wonders and portents that occurred in Rome between 249 BC-12 BC.", ["The", "only", "work", "associated", "with", "his", "name", "is", "the", "Liber", "de", "prodigiis", "(", "Book", "of", "Prodigies", ")", ",", "completely", "extracted", "from", "an", "epitome", ",", "or", "abridgment", ",", "written", "by", "Livy", ";", "De", "prodigiis", "was", "constructed", "as", "an", "account", "of", "the", "wonders", "and", "portents", "that", "occurred", "in", "Rome", "between", "249", "BC-12", "BC", "."]],
          ["Of great importance was the edition by the Basle Humanist Conrad Lycosthenes (1552), trying to reconstruct lost parts and illustrating the text with wood-cuts.", ["Of", "great", "importance", "was", "the", "edition", "by", "the", "Basle", "Humanist", "Conrad", "Lycosthenes", "(", "1552", ")", ",", "trying", "to", "reconstruct", "lost", "parts", "and", "illustrating", "the", "text", "with", "wood-cuts", "."]],
          ["These have been interpreted as reports of unidentified flying objects (UFOs), but may just as well describe meteors, and, since Obsequens, probably, writes in the 4th century, that is, some 400 years after the events he describes, they hardly qualify as eye-witness accounts.", ["These", "have", "been", "interpreted", "as", "reports", "of", "unidentified", "flying", "objects", "(", "UFOs", ")", ",", "but", "may", "just", "as", "well", "describe", "meteors", ",", "and", ",", "since", "Obsequens", ",", "probably", ",", "writes", "in", "the", "4th", "century", ",", "that", "is", ",", "some", "400", "years", "after", "the", "events", "he", "describes", ",", "they", "hardly", "qualify", "as", "eye-witness", "accounts", "."]],
          ['"At Aenariae, while Livius Troso was promulgating the laws at the beginning of the Italian war, at sunrise, there came a terrific noise in the sky, and a globe of fire appeared burning in the north.', ["\"", "At", "Aenariae", ",", "while", "Livius", "Troso", "was", "promulgating", "the", "laws", "at", "the", "beginning", "of", "the", "Italian", "war", ",", "at", "sunrise", ",", "there", "came", "a", "terrific", "noise", "in", "the", "sky", ",", "and", "a", "globe", "of", "fire", "appeared", "burning", "in", "the", "north", "."]]
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
          ["Qala is first referred to in a fifteenth century portolan preserved at the Vatican library has taken its name from the qala or port of Mondoq ir-Rummien. It is the easternmost village of Gozo and has been inhabited since early times. The development of the present settlement began in the second half of the seventeenth century. It is a pleasant and rural place with many natural and historic attractions.", ["Qala is first referred to in a fifteenth century portolan preserved at the Vatican library has taken its name from the qala or port of Mondoq ir-Rummien.", "It is the easternmost village of Gozo and has been inhabited since early times.", "The development of the present settlement began in the second half of the seventeenth century.", "It is a pleasant and rural place with many natural and historic attractions."]],
          ["Originally Radio Lehen il-Qala transmitted on frequency 106.5FM. But when consequently a national radio started transmissions on a frequency quite close, it caused a hindrance to our community radio." "People were complaining that the voice of the local radio was no longer clear and they were experiencing difficulty in following the programmes. This was a further proof of the value of the radio. It was a confirmation that it was a good and modern means of bringing the Christian message to the whole community. An official request was therefore made to the Broadcasting Authority and Radio Lehen il-Qala was given a new frequency - 106.3FM.", ["Originally Radio Lehen il-Qala transmitted on frequency 106.5FM.", "But when consequently a national radio started transmissions on a frequency quite close, it caused a hindrance to our community radio.", "People were complaining that the voice of the local radio was no longer clear and they were experiencing difficulty in following the programmes.", "This was a further proof of the value of the radio.", "It was a confirmation that it was a good and modern means of bringing the Christian message to the whole community.", "An official request was therefore made to the Broadcasting Authority and Radio Lehen il-Qala was given a new frequency - 106.3FM."]]
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
