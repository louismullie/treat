require 'date'
require 'rspec/core/rake_task'

namespace :treat do

  task :default => :spec

  RSpec::Core::RakeTask.new do |t|
    t.pattern = "./spec/**/*_spec.rb"
  end

  task :version do
    contents = File.read File.expand_path('../lib/treat.rb', __FILE__)
    contents[/VERSION = "([^"]+)"/, 1]
  end

  task :install, [:language] do |t, args|
    require './lib/treat'
    Treat.install(args.language)
  end

end
