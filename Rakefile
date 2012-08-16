require 'date'
require 'rspec/core/rake_task'

namespace :treat do
  
  # task :spec
  RSpec::Core::RakeTask.new do |t|
    task = ARGV[0].scan(/\[([a-z_]*)\]/)
    if task && task.size == 0
      t.pattern = "./spec/*.rb"
    else
      t.pattern = "./spec/#{task[0][0]}.rb"
    end
    # t.ruby_opts = '-w'
  end
  
  task :version do
    path = '../lib/treat/version.rb'
    file = File.expand_path(path, __FILE__)
    contents = File.read(file)
    puts contents[/VERSION = "([^"]+)"/, 1]
  end

  task :install, [:language] do |t, args|
    require './lib/treat'
    Treat.install(args.language || 'english')
  end
  
  task :benchmark do
    require './lib/treat'
    require './spec/languages/benchmark'
    
    task = ARGV[0].scan(/\[([a-z_]*)\]/)
    
    if task && task.size == 0
      pattern = "./spec/languages/*.rb"
    else
      pattern = "./spec/languages/#{task[0][0]}.rb"
    end
    
    Dir.glob(pattern).each do |file|
      require file
    end
    
    Treat::Spec::Languages.constants.each do |cst|
      next if cst == :Benchmark
      Treat::Spec::Languages.const_get(cst).new.run :benchmarks
    end
  end

end