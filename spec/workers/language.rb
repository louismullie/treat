module Treat::Specs::Workers

  class Language

    @@list = []

    # Add the language to the list,
    # and define an initialize method.
    def self.inherited(base)
      @@list << base
      base.class_eval do
        def initialize
          @language = cl(self.class).downcase
          @scenarios = Scenarios
        end
      end
    end

    # Return the list of registered languages.
    def self.list; @@list; end

    # Default options for #run.
    DefaultOptions = { save_html: true }

    # Runs the benchmarks or spec tasks.
    def run(what, options = {})
      options = DefaultOptions.merge(options)
      run_for_all(what, Treat.
      languages[@language].workers)
      if what == :benchmarks
        print_table(results)
        if options[:save_html]
          save_html(results)
        end
      end
    end

    # Run the method on a list of workers.
    def run_for_all(method, workers)
      results = []
      workers.members.each do |cat|
        category = workers[cat]
        category.members.each do |grp|
          group = category[grp]
          group_class = Treat::Workers.
          const_get(cc(cat)).
          const_get(cc(grp))
          #next unless [:topics].
          #include?(group_class.method)
          group.each do |worker|
            results << send(method,
            worker, group_class)
          end
        end
      end
      results
    end

    def get_worker_info(worker, group)
      bits = group.to_s.split('::')
      bits.collect! { |bit| ucc(bit) }
      file = bits.join('/') + "/#{worker}.rb"
      contents = File.read(Treat.paths.lib + file)
      head = contents[0...contents.index('class')]
      parts = head.gsub("\n# ", "\n").gsub('#', '').
      gsub('encoding: utf-8', '').
      gsub(/Authors: (.*)/m, '').
      gsub(/License: (.*)/m, '').
      gsub(/Website: (.*)/m, '').
      split('Original paper: ')
      {description: parts[0],
      reference: parts[1]}
    end

    # Run benchmarks on a worker.
    def benchmark(worker, group)
      info = get_worker_info(worker, group_class)
      time = ::Benchmark.measure do |x|
        accuracy = run_scenarios(
        'benchmark', worker, group)
      end
      # Return a row for the table.
      [ method.to_s, worker.to_s,
        description.strip,
        reference ? reference : '-',
        time.utime.round(4).to_s,
        time.stime.round(4).to_s,
        time.real.round(4).to_s,
        accuracy ]
    end

    # Run examples as specs on each
    # of the worker's target entities.
    def spec(worker, group)
      run_scenarios('spec', worker, group)
    end
    
    # Run a scenario (i.e. spec or benchmark
    # all workers available to perform a given
    # method call in a certain language).
    def run_scenarios(mode, worker, group)
      accuracy = 0; i = 0; n = 0
      method = "run_#{mode}s"
      group.targets.each do |target|
        next if target == :section ### FIXME
        scenario = @scenarios[group.method][target]
        i2, n2 = send(method, worker, group, scenario, target)
        i += i2; n += n2
      end
      # Return the accuracy of the worker.
      (i.to_f/n.to_f*100).round(2)
    end
    
    # Run a scenario as a benchmark, emitting
    # a pair of (# passed, # failed) examples.
    def run_benchmarks(worker, group, scenario)
      if scenario[:examples].is_a?(Hash)
        i, n = run_presets(worker, group, scenario)
      else
        i, n = Treat::Specs::Workers::Language.
        run_examples(worker, group, scenario, options)
      end
      [i, n]
    end

    def run_specs(worker, group, scenario, target)
      does = Treat::Specs::Workers::
      Descriptions[group.method]
      i = 0; n = 0;
      describe group do
        context "when it is called on a #{target}" do
          if scenario[:examples].is_a?(Hash)
            preset_examples = scenario[:examples]
            preset_examples.each do |preset, examples|
              context "and #{group.preset_option} is set to #{preset}" do
                it does do
                  options = {group.preset_option => preset}
                  bm = scenario.dup; bm[:examples] = examples
                  i2, n2 = *Treat::Specs::Workers::Language.
                  run_examples(worker, group, scenario, target, options)
                  (i2.to_f/n2.to_f*100).round(2).should eql 100.0
                  i += i2; n += n2
                end
              end
            end
          else
            it does do
              i, n = Treat::Specs::Workers::Language.
              run_examples(worker, group, scenario, target)
              (i.to_f/n.to_f*100).round(2).should eql 100.0
            end
          end
          # Check for accuracy.
        end
      end
      [i, n]
    end

    # Runs a benchmark for each preset.
    def run_presets(worker, group, scenario)
      i, n = 0, 0
      examples = scenario[:examples]
      examples.each do |preset, examples|
        options = {group.preset_option => preset}
        sc = scenario.dup; sc[:examples] = examples
        i2, n2 = Treat::Specs::Workers::Language.
        run_examples(worker, group, scenario, options)
        i += i2; n += n2
      end
      [i, n]
    end

    def self.run_examples(worker, group, scenario, target, options = {})

      i = 0; n = 0
      examples, generator,
      preprocessor =
      scenario[:examples],
      scenario[:generator],
      scenario[:preprocessor]
      target_class = Treat::Entities.
      const_get(cc(target))

      examples.each do |example|
        value, expectation = *example
        entity = target_class.build(value)
        preprocessor.call(entity) if preprocessor
        if generator
          result = entity.send(group.method, worker, options)
          operand = (group.type == :computer ? result : entity)
          result = generator.call(operand)
        else
          result = entity.send(group.method, worker, options)
        end
        i += 1 if result == expectation
        n += 1
      end

      [i, n]

    end

  end

end