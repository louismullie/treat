require 'date'
require 'rspec/core/rake_task'

namespace :treat do

  task :default => :spec
  
  RSpec::Core::RakeTask.new do |t|
    
    task = ARGV[0].scan(/\[([a-z]*)\]/)
    
    if task && task.size == 0
      t.pattern = "./spec/*.rb"
    else
      t.pattern = "./spec/#{task[0][0]}.rb"
    end
    
  end

  task :version do
    contents = File.read File.expand_path('../lib/treat.rb', __FILE__)
    contents[/VERSION = "([^"]+)"/, 1]
  end

  task :install, [:language] do |t, args|
    require './lib/treat'
    l = args.language
    l ||= 'english'
    Treat.install(l)
  end

end