require 'date'

# All commands are prefixed with "treat:".
namespace :treat do

  # Returns the current version of Treat.
  # Syntax: rake treat:version
  task :version do
    # Parse out the version number from file.
    path = '../lib/treat/version.rb'
    file = File.expand_path(path, __FILE__)
    contents = File.read(file)
    puts contents[/VERSION = "([^"]+)"/, 1]
  end

  # Install a language pack (default to english).
  # Syntax: rake treat:install[language]
  task :install, [:language] do |t, args|
    require './lib/treat'
    Treat.install(args.language || 'english')
  end
  
  # Runs the specs for the core library
  # and for all languages (default) or 
  # a specific language (if specified).
  # Syntax: rake treat:spec[language]
  task :spec, [:language] do |t, args|
    
    # Must be required first.
    require 'simplecov'
    require './spec/helper'
    
    # Get a list of all folders.
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
    
    # Require all the necessary examples.
    Treat::Specs::Helper.
    require_languages(args.language, t)
    
    # Run all of the benchmark examples.
    Treat::Specs::Workers::Language.
        list.each do |lang|
      lang.new.run(:specs)
    end
    
    # Require the core and entity specs.
    files = Dir.glob('./spec/core/*.rb') +
    Dir.glob('./spec/entities/*.rb')

    # Run all the spec files.
    RSpec::Core::Runner.run(
    files, $stderr, $stdout)
    
  end
  
  # Benchmark all languages (default) or a 
  # specific language (if argument supplied).
  # Syntax: rake treat:benchmark[language]
  task :benchmark, [:language] do |t, args|

    require './spec/helper'
    
    # Require the right benchmark files.
    Treat::Specs::Helper.
    require_languages(args.language, t)

    Treat::Specs::Workers::Language.
      list.each do |lang|
        lang.new.run(:benchmarks)
    end
    
  end

end
