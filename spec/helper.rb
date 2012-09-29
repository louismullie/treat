require_relative '../lib/treat'
module Treat::Specs

  # Require the worker specs.
  require_relative 'workers'
  # Require RSpec library.
  require 'rspec'
  # Require Ruby benchmark library.
  require 'benchmark'
  # Require gem to build ASCII tables.
  
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
  
  # Provide helper functions for running specs.
  class Helper
    
    # Run all worker example files as :specs
    # or :benchmarks for the given language.
    def self.run_examples_as(what, language)
       require_languages(args.language, t)
      Treat::Specs::Workers::Language.
        list.each do |lang|
          lang.new(what).run
      end
    end
    
    # Run specs for the core classes.
    def self.run_core_specs
      files = Dir.glob('./spec/core/*.rb') +
      Dir.glob('./spec/entities/*.rb')
      # Run all the spec files.
      RSpec::Core::Runner.run(
      files, $stderr, $stdout)
    end
    
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
    
    # Require language files based on the argument.
    def self.require_languages(arg)
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
          raise Treat::Exception, 
          "No example file exists for language '#{arg}'."
        end
      end
      # Require all files matched by the pattern.
      Dir.glob(pattern).each { |f| require f }
    end
    
    def self.text_table(headings, rows)
      require 'terminal-table'
      puts Terminal::Table.new(
      headings: headings, rows: rows)
    end

    def self.html_table(headings, rows)
      require 'fileutils'
      html = "<table>\n"
      html += "<tr>\n"
      headings.each do |heading|
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