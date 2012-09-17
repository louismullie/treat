require 'date'

namespace :treat do

  task :spec do
    
    require 'simplecov'
    require 'rspec'
    
    SimpleCov.start do

      add_filter '/spec/'
      add_filter '/config/'

      add_group 'Core', 'treat/core'
      add_group 'Entities', 'treat/entities'
      add_group 'Helpers', 'treat/helpers'
      add_group 'Loaders', 'treat/loaders'
      add_group 'Workers', 'treat/workers'
      add_group 'Config', 'config.rb'
      add_group 'Proxies', 'proxies.rb'
      add_group 'Treat', 'treat.rb'

    end
    
    # Require benchmarks and run them all.
    require './spec/workers/language'
    Dir.glob('./spec/workers/*.rb').each do |file|
      require file
    end
    
    Treat::Specs::Workers.constants.each do |cst|
      next if cst == :Language
      Treat::Specs::Workers.const_get(cst).new.run :specs
    end
    
    # Require the core and entit specs.
    files = Dir.glob('./spec/core/*.rb') +
    Dir.glob('./spec/entities/*.rb')
    
    RSpec::Core::Runner.run(
    files, $stderr, $stdout)
    
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
    require './spec/workers/language'

    task = ARGV[0].scan(/\[([a-z_]*)\]/)

    if task && task.size == 0
      pattern = "./spec/workers/*.rb"
    else
      pattern = "./spec/workers/#{task[0][0]}.rb"
    end

    Dir.glob(pattern).each do |file|
      require file
    end

    Treat::Specs::Workers.constants.each do |cst|
      next if cst == :Language
      Treat::Specs::Workers.
      const_get(cst).new.run :benchmarks
    end
  end

end
