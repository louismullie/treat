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
    Dir.glob('./perf/*.rb').each do |file|
      require file
    end
    Treat::Benchmarks.constants.each do |cst|
      Treat::Benchmarks.const_get(cst).run
    end
  end

end