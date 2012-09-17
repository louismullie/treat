module Treat::Specs
  
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

  # Require Ruby benchmark library.
  require 'benchmark'
  # Require gem to build ASCII tables.
  require 'terminal-table'
  
  # Provide helper functions for running specs.
  class Helper
    
    # Require language files based on the argument.
    def self.require_languages(arg, task)
      # Require the base language class.
      require_relative 'workers/language'
      # If no language supplied, get all languages.
      if !arg || arg == ''
        pattern = "./spec/workers/*.rb"
      # Otherwise, get a specific language file.
      else
        pattern = "./spec/workers/#{arg}.rb"
        # Check if a spec file exists.
        unless File.readable?(pattern)
          task = task.name.split(':').last
          raise Treat::Exception, 
          "No #{task} file exists for language '#{arg}'."
        end
      end
      # Require all files matched by the pattern.
      Dir.glob(pattern).each { |f| require f }
    end
    
  end
  
end