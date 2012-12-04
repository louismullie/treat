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
    
    ModuleFiles = [
      './spec/core/*.rb', 
      './spec/entities/*.rb'
    ]
    
    # Run all worker example files as :specs
    # or :benchmarks for the given language.
    def self.run_examples_as(what, language)
      self.require_language_files(language)
      Treat::Specs::Workers::Language.
      list.each { |l| l.new(what).run }
      RSpec::Core::CommandLine.new([]).run($stderr, $stdout)
    end
    
    # Run specs for the core classes.
    def self.run_core_specs
      RSpec::Core::Runner.run(
      ModuleFiles.map { |d| Dir.glob(d) }, 
      $stderr, $stdout)
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
    def self.require_language_files(arg)
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
          "There are no examples for '#{arg}'."
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
      self.write_html('benchmark', html)
    end
    
    def self.write_html(dir, html)
      unless FileTest.directory?(dir) 
        FileUtils.mkdir('./' + dir) 
      end
      fn = "./#{dir}/index.html"
      File.open(fn, 'w+') { |f| f.write(html) }
    end
    
  end
  
end