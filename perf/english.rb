require_relative '../lib/treat'

Treat.libraries.stanford.model_path =
'/ruby/stanford/stanford-core-nlp-all/'
Treat.libraries.stanford.jar_path =
'/ruby/stanford/stanford-core-nlp-all/'
Treat.libraries.punkt.model_path =
'/ruby/punkt/'

module Treat::Benchmarks
  require 'benchmark'
  require 'terminal-table'
end

# module Treat::Benchmarks::Language; end

# class Treat::Benchmarks::Agnostic; end
class Treat::Benchmarks::English
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
    }
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
        next unless [:segment, :language, :category].include?(group_class.method)   # :segment, :tokenize, :tag, :ordinal, :cardinal, :name_tag, :stem, :time,
        group.each do |worker|
          results << self.run_benchmark(
          group_class, worker)
        end
      end
    end

    print_table(results)

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
        benchmark = Benchmarks[method][target]
        examples = benchmark[:examples]
        i2 = 0; n2 = 0
        if examples.is_a?(Hash)
          examples.each do |preset, example|
            options = {group_class.preset => preset}
            i2, n2 = *self.run_examples(method,
            worker, target, benchmark, options)
          end
        else
          puts "yes"
          i2, n2 = *self.run_examples(method,
          worker, target, benchmark)
        end
        i += i2; n += n2
      end
      puts [i, n].inspect
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
      entity = target_class.new(value)
      if preprocessor
        entity = preprocessor.call(entity)
      end
      
      if generator
        entity.send(method, worker, options)
        result = generator.call(entity)
        i += 1 if result == expectation
      else
        i += 1 if example.send(method,
        worker, options) == expectation
      end
      
      n += 1
    end

    [i, n]

  end
  
  
  def self.print_table(rows)
    headings = ['Task', 'Worker',
      'Description', 'Reference', 'User',
    'System', 'Real', 'Accuracy']
    puts Terminal::Table.new(
    headings: headings, rows: rows)
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
    split('Original paper: ')
  end

end
