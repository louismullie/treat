module Treat::Spec
  
  module Languages

    Treat.libraries.stanford.model_path =
    '/ruby/stanford/stanford-core-nlp-all/'
    Treat.libraries.stanford.jar_path =
    '/ruby/stanford/stanford-core-nlp-all/'
    Treat.libraries.punkt.model_path =
    '/ruby/punkt/'
    Treat.libraries.reuters.model_path =
    '/ruby/reuters/'

    require 'benchmark'
    require 'rspec'
    require 'terminal-table'

    class Benchmark

      Headings = ['Task', 'Worker',
        'Description', 'Reference', 'User',
      'System', 'Real', 'Accuracy']

      def initialize(benchmarks, language = 'english')
        @benchmarks, @language =
        benchmarks, language
      end

      def run(what)
        return if @language == 'agnostic' ## FIXME
        method = "run_#{what}"
        workers = Treat.languages[@language].workers
        results = []

        workers.members.each do |cat|
          category = workers[cat]
          category.members.each do |grp|

            group = category[grp]
            group_class = Treat::Workers.
            const_get(cc(cat)).
            const_get(cc(grp))
          
            next unless [:segment].
            include?(group_class.method)
            
            group.each do |worker|
              #next unless worker == :stanford
              results << send(method,
              group_class, worker)
            end
          end
        end

        if what == :benchmarks
          print_table(results)
          save_html(results)
        end

      end

      def run_benchmarks(group_class, worker)

        description, reference =
        *get_description(group_class, worker)
        method = group_class.method
        targets = group_class.targets
        accuracy = 0

        time = ::Benchmark.measure do |x|

          i = 0; n = 0

          targets.each do |target|
            next if target == :section ### FIXME
            benchmark = @benchmarks[method][target]
            examples = benchmark[:examples]
            i2 = 0; n2 = 0
            if examples.is_a?(Hash)
              preset_examples = benchmark[:examples]
              preset_examples.each do |preset, examples|
                options = {group_class.preset_option => preset}
                bm = benchmark.dup; bm[:examples] = examples
                i2, n2 = *Treat::Spec::Languages::Benchmark.
                run_tests(method, worker, target, bm, options)
              end
            else
              i2, n2 = Treat::Spec::Languages::Benchmark.
              run_tests(method, worker, target, benchmark)
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

      def run_specs(group_class, worker)

        description, reference =
        *get_description(group_class, worker)
        method = group_class.method
        targets = group_class.targets
        
        targets.each do |target|
          next if target == :section ### FIXME
          benchmark = @benchmarks[method][target]
          examples = benchmark[:examples]
          describe group_class do
            context "it is supplied with a lol" do
              it "returns a lol" do
                if examples.is_a?(Hash)
                  preset_examples = benchmark[:examples]
                  i = 0; n = 0;
                  preset_examples.each do |preset, examples|
                    options = {group_class.preset_option => preset}
                    bm = benchmark.dup; bm[:examples] = examples
                    i2, n2 = *Treat::Spec::Languages::Benchmark.
                    run_tests(method, worker, target, bm, options)
                    i += i2; n += n2
                  end
                else
                  i, n = Treat::Spec::Languages::Benchmark.
                  run_tests(method, worker, target, benchmark)
                end
                # Check for accuracy.
                (i.to_f/n.to_f*100).round(2).should eql 100.0
              end
            end
          end

        end

      end


      def get_description(group_class, worker)
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

      def self.run_tests(method, worker, target, benchmark, options = {})
        
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
          else
            result = entity.send(method, worker, options)
          end
          puts result.inspect
          puts method.to_s + " --- " + worker.to_s
          i += 1 if result == expectation
          puts "\nPASSES" if result == expectation
          n += 1
        end

        [i, n]

      end

      def print_table(rows)
        puts Terminal::Table.new(
        headings: Headings, rows: rows)
      end

      def save_html(rows)
        require 'fileutils'
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
        FileUtils.mkdir('./benchmark') unless 
        FileTest.directory?('./benchmark')
        File.open('./benchmark/index.html', 'w+') do |f|
          f.write(html)
        end
      end

    end
  end
end
