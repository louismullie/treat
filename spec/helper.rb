module Treat::Specs

  # Require Treat core files.
  require './lib/treat'
  require './spec/workers'
  # Require RSpec library.
  require 'rspec'
  # Require Ruby benchmark library.
  require 'benchmark'
  # Require gem to build ASCII tables.
  require 'terminal-table'
  
  # Some configuration options for devel.
  #Treat.databases.mongo.db = 'treat_test'
  #Treat.libraries.stanford.model_path =
  #'/ruby/stanford/stanford-core-nlp-all/'
  #Treat.libraries.stanford.jar_path =
  #'/ruby/stanford/stanford-core-nlp-all/'
  #Treat.libraries.punkt.model_path =
  #'/ruby/punkt/'
  #Treat.libraries.reuters.model_path =
  #'/ruby/reuters/'
  
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
    
    def self.html_table(headings, rows)
      puts Terminal::Table.new(
      headings: headings, rows: rows)
    end

    def self.text_table(headings, rows)
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