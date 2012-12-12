require_relative '../lib/treat'

module Treat::Specs

  require 'rspec'
  
  # Some configuration options for devel.
  Treat.databases.mongo.db = 'treat_test'
  Treat.libraries.stanford.model_path =
  '/ruby/stanford/stanford-core-nlp-all/'
  Treat.libraries.stanford.jar_path =
  '/ruby/stanford/stanford-core-nlp-all/'
  Treat.libraries.punkt.model_path =
  '/ruby/punkt/'
  Treat.libraries.reuters.model_path =
  '/ruby/reuters/'
  
  ModuleFiles = ['./entities/*.rb', './learning/*.rb']
  
  # Provide helper functions for running specs.
  class Helper
    
    # Start SimpleCov coverage.
    def self.start_coverage
      require 'simplecov'
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
    end
    
    # Run specs for the core classes.
    def self.run_core_specs
      files = ModuleFiles.map { |d| Dir.glob(d) }
      RSpec::Core::Runner.run(files)
    end
    
    # Require language files based on the argument.
    def self.run_language_specs(lang)
      # If no language supplied, get all languages.
      if !lang || lang == ''
        pattern = "./spec/workers/*.rb"
      # Otherwise, get a specific language file.
      else
        pattern = "./spec/workers/#{lang}.rb"
        unless File.readable?(pattern)
          raise Treat::Exception, 
          "There are no examples for '#{lang}'."
        end
      end
      RSpec::Core::Runner.run(Dir.glob(pattern))
    end
    
  end
  
end