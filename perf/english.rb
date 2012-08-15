require_relative '../lib/treat'

Treat.libraries.stanford.model_path =
'/ruby/stanford/stanford-core-nlp-all/'
Treat.libraries.stanford.jar_path =
'/ruby/stanford/stanford-core-nlp-all/'
Treat.libraries.punkt.model_path =
'/ruby/punkt/'
Treat.libraries.reuters.model_path =
'/ruby/reuters/'

module Treat::Benchmarks
  require 'benchmark'
  require 'terminal-table'
end

# module Treat::Benchmarks::Language; end

# class Treat::Benchmarks::Agnostic; end
class Treat::Benchmarks::English
  Headings = ['Task', 'Worker',
    'Description', 'Reference', 'User',
  'System', 'Real', 'Accuracy']
  Benchmarks = {
    tokenize: {
      group: {
        examples: [
          ["A test phrase", ["A", "test", "phrase"]]
        ],
        generator: lambda { |entity| entity.tokens.map { |tok| tok.to_s } }
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
          ["./perf/examples/test.txt", ['household goods and hardware', 'united states of america', 'corporate/industrial']]
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
  def self.run

    lang = cl(self).downcase
    workers = Treat.languages[lang].workers
    results = []

    workers.members.each do |cat|
      category = workers[cat]
      category.members.each do |grp|

        group = category[grp]
        group_class = Treat::Workers.
        const_get(cc(cat)).
        const_get(cc(grp))
        puts group_class.method
        next unless [:category].
        include?(group_class.method)
        # ??: :language
        # TODO: :keywords, :tf_idf, :topic_words
        # :read, :visualize, :serialize, :unserialize, :search, 
        # :index, :sense, :parse, :classify
        # DONE: :segment, :tokenize, :tag, :ordinal, :cardinal, 
        # :name_tag, :stem, :time, :topics, :conjugate, :declense,
        # :sense, :category
        group.each do |worker|
          results << self.run_benchmark(
          group_class, worker)
        end
      end
    end

    print_table(results)
    save_html(results)

  end

  def self.run_benchmark(group_class, worker)

    description, reference =
    *self.get_description(group_class, worker)
    method = group_class.method
    targets = group_class.targets
    accuracy = 0

    time = Benchmark.measure do |x|

      i = 0; n = 0

      targets.each do |target|
        next if target == :section ### FIXME
        benchmark = Benchmarks[method][target]
        examples = benchmark[:examples]
        i2 = 0; n2 = 0
        if examples.is_a?(Hash)
          preset_examples = benchmark[:examples]
          preset_examples.each do |preset, examples|
            options = {group_class.preset_option => preset}
            bm = benchmark.dup; bm[:examples] = examples
            i2, n2 = *self.run_examples(method,
            worker, target, bm, options)
          end
        else
          i2, n2 = *self.run_examples(method,
          worker, target, benchmark)
        end
        i += i2; n += n2
      end

      accuracy = (i.to_f/n.to_f*100).round(2)

    end

    [ method.to_s, worker.to_s,
      description.strip,
      reference ? reference : '-',
      time.utime.round(4).to_s,
      time.stime.round(4).to_s,
      time.real.round(4).to_s,
    accuracy ]

  end

  def self.run_examples(method, worker, target, benchmark, options = {})

    i = 0; n = 0
    examples, generator,
    preprocessor =
    benchmark[:examples],
    benchmark[:generator],
    benchmark[:preprocessor]
    target_class = Treat::Entities.
    const_get(cc(target))

    examples.each do |example|
      value, expectation = *example
      entity = target_class.build(value)
      preprocessor.call(entity) if preprocessor
      if generator
        entity.send(method, worker, options)
        result = generator.call(entity)
        i += 1 if result == expectation
      else
        i += 1 if entity.send(method,
        worker, options) == expectation
      end

      n += 1
    end

    [i, n]

  end


  def self.print_table(rows)
    puts Terminal::Table.new(
    headings: Headings, rows: rows)
  end

  def self.save_html(rows)
    html = "<table>\n"
    html += "<tr>\n"
    Headings.each do |heading|
      html += "<td>" + heading + "</td>\n"
    end
    html += "</tr>\n"
    rows.each do |row|
      html += "<tr>\n"
      row.each do |el|
        html += "<td>#{el}</td>"
      end
      html += "</tr>\n"
    end
    File.open('report.html', 'w') do |f|
      f.write(html)
    end
  end

  def self.get_description(group_class, worker)
    bits = group_class.to_s.split('::')
    bits.collect! { |bit| ucc(bit) }
    file = bits.join('/') + "/#{worker}.rb"
    contents = File.read(Treat.paths.lib + file)
    head = contents[0...contents.index('class')]
    head.gsub("\n# ", "\n").gsub('#', '').
    gsub('encoding: utf-8', '').
    gsub(/Authors: (.*)/m, '').
    gsub(/License: (.*)/m, '').
    gsub(/Website: (.*)/m, '').
    split('Original paper: ')
  end

end
