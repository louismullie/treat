module Treat::Specs::Workers

  class Language

    @@list = []

    # Headings for the list of workers table.
    BenchmarkHeadings =
    ['Method', 'Worker', 'Description', 
    'Reference', 'User time', 'System time',
    'Real time', 'Accuracy']

    # Add the language to the list,
    # and define an initialize method.
    def self.inherited(base)
      @@list << base
      base.class_eval do
        def initialize(mode)
          klass = self.class.const_get(:Scenarios)
          @scenarios, @mode = klass, mode
          @language = cl(self.class).downcase
        end
      end
    end

    # Return the list of registered languages.
    def self.list; @@list; end

    # Default options for #run.
    DefaultOptions = { save_html: true }

    # Runs the benchmarks or spec tasks.
    def run(options = {})
      options = DefaultOptions.merge(options)
      results = run_scenarios
      if @mode == 'benchmark'
        l = @language.capitalize
        print "\n\nBenchmark for #{l}\n"
        Treat::Specs::Helper.text_table(
        BenchmarkHeadings, results)
        if options[:save_html]
          Treat::Specs::Helper.html_table(
          BenchmarkHeadings, results)
        end
      end
    end

    # Run all scenarios for a language, for all of the
    # algorithm categories (e.g. Processors, Extractors).
    def run_scenarios
      categories = Treat.languages[
      @language].workers
      results = []
      method = "run_scenarios_as_#{@mode}s"
      categories.members.each do |cat|
        category = categories[cat]
        category.members.each do |grp|
          group = category[grp]
          group_class = Treat::Workers.
          const_get(cc(cat)).
          const_get(cc(grp))
          #next unless group_class ==
          #Treat::Workers::Learners::Classifiers
          group.each do |worker|
            next if worker == :mongo  # FIXME
            next if worker == :html   # FIXME
            next if worker == :lda
            next if worker == :linear
            next if worker == :svm
            results << send(method,
            worker, group_class)
          end
        end
      end
      results
    end

    # Run all benchmarks.
    def run_scenarios_as_benchmarks(worker, group)
      info = get_worker_info(worker, group)
      description, reference =
      info[:description], info[:reference]
      accuracy = 0
      time = ::Benchmark.measure do |x|
        accuracy = run_scenarios_for_all_workers(
        worker, group, 'benchmark')
      end
      # Return a row for the table.
      [ group.method.to_s, worker.to_s,
        description.strip,
        reference ? reference : '-',
        time.utime.round(4).to_s,
        time.stime.round(4).to_s,
        time.real.round(4).to_s,
        accuracy ]
    end

    # Run examples as specs on each
    # of the worker's target entities.
    def run_scenarios_as_specs(worker, group)
      run_scenarios_for_all_workers(worker, group, 'spec')
    end

    # Run a scenario (i.e. spec or benchmark
    # all workers available to perform a given
    # method call in a certain language).
    def run_scenarios_for_all_workers(worker, group, mode)
      accuracy = 0; i = 0; n = 0
      method = "run_worker_#{mode}s"
      group.targets.each do |target|
        next if target == :section ### FIXME
        i2, n2 = send(method, worker, group, target)
        i += i2; n += n2
      end
      # Return the accuracy of the worker.
      accuracy = (i.to_f/n.to_f*100).round(2)
      accuracy
    end

    # Run all examples available to test the worker
    # on a given target entity type as benchmarks.
    # Outputs [# successes, # tries].
    def run_worker_benchmarks(worker, group, target)
      scenario = find_scenario(group.method, target)
      return [0, 1] unless scenario
      scenario = @scenarios[group.method][target]
      if scenario[:examples].is_a?(Hash)
        i, n = run_scenario_presets(
        worker, group, target, scenario)
      else
        i, n = Treat::Specs::Workers::Language.
        run_examples(worker, group, target, scenario)
      end
      [i, n]
    end


    # Run all examples available to test the worker
    # on a given target entity type as RSpec tests.
    def run_worker_specs(worker, group, target)
      scenario = find_scenario(group.method, target)
      return [0, 1] unless scenario
      does = Treat::Specs::Workers::
      Descriptions[group.method]
      i = 0; n = 0;
      describe group do
        context "when it is called on a #{target}" do
          if scenario[:examples].is_a?(Hash) && group.preset_option
            preset_examples = scenario[:examples]
            preset_examples.each do |preset, examples|
              context "and #{group.preset_option} is set to #{preset}" do
                it does[preset] do
                  options = {group.preset_option => preset}
                  bm = scenario.dup; bm[:examples] = examples
                  i2, n2 = *Treat::Specs::Workers::Language.
                  run_examples(worker, group, target, bm, options)
                  (i2.to_f/n2.to_f*100).round(2).should eql 100.0
                  i += i2; n += n2
                end
              end
            end
          else
            it does do
              i, n = Treat::Specs::Workers::Language.
              run_examples(worker, group, target, scenario)
              (i.to_f/n.to_f*100).round(2).should eql 100.0
            end
          end
          # Check for accuracy.
        end
      end
      [i, n]
    end

    def self.run_examples(worker, group, target, scenario, options = {})
      i = 0; n = 0
      examples, generator, preprocessor =
      scenario[:examples], scenario[:generator],
      scenario[:preprocessor]
      target_class = Treat::Entities.
      const_get(cc(target))
      if examples.is_a?(Hash)
        unless examples[worker]
          raise Treat::Exception,
          "No example defined for worker #{worker}."
        end
        examples = examples[worker]
      end
      examples.each do |example|
        value, expectation, options2 = *example
        entity = target_class.build(value)
        begin
          if preprocessor
            preprocessor.call(entity)
          end
          if options2.is_a?(::Proc)
            options2 = options2.call
          end
          options = options.merge(options2 || {})
          if generator
            result = entity.send(group.
            method, worker, options)
            operand = (group.type ==
            :computer ? result : entity)
            result = generator.call(operand)
          else
            result = entity.send(group.
            method, worker, options)
          end
        rescue Treat::Exception => e
          puts e.message
          next
        end
        puts result.inspect
        i += 1 if result == expectation
        n += 1
      end
      (i == 0 && n == 0) ? [1, 1] : [i, n]
    end

    # * Helpers * #

    # Given a method and a target,
    # find a scenario for the current
    # language class instance.
    def find_scenario(method, target)
      unless @scenarios[method]
        puts "Warning: there is no scenario for " +
        "method ##{method} called on " +
        "#{target.to_s.plural} in the " +
        "#{@language.capitalize} language."
        return nil
      end
      unless @scenarios[method]
        puts "Warning: there is a scenario for " +
        "method ##{method} in the " +
        "#{@language.capitalize} language, " +
        "but there are no examples for target " +
        "entity type '#{target.to_s.plural}'."
        return nil
      end
      @scenarios[method][target]
    end

    # Parse out the description and reference from
    # the Ruby file defining the worker/adapter.
    def get_worker_info(worker, group)
      bits = group.to_s.split('::')
      bits.collect! { |bit| ucc(bit) }
      file = bits.join('/') + "/#{worker}.rb"
      contents = File.read(Treat.paths.lib + file)
      head = contents[0...contents.index('class')]
      parts = head.gsub("\n# ", "\n").gsub('#', '').
      gsub('encoding: utf-8', '').
      gsub(/Authors: (.*)/m, ''). # ouch
      gsub(/License: (.*)/m, '').
      gsub(/Website: (.*)/m, '').
      split('Original paper: ')
      {description: parts[0] || '',
      reference: parts[1] || '-'}
    end

    # Runs a benchmark for each preset.
    def run_scenario_presets(worker, group, target, scenario)
      i, n = 0, 0
      examples = scenario[:examples]
      examples.each do |preset, examples|
        options = {group.preset_option => preset}
        sc = scenario.dup; sc[:examples] = examples
        i2, n2 = Treat::Specs::Workers::Language.
        run_examples(worker, group, target, sc, options)
        i += i2; n += n2
      end
      [i, n]
    end

  end

end
