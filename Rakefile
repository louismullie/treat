require 'date'

def version
  contents = File.read File.expand_path('../lib/treat.rb', __FILE__)
  contents[/VERSION = "([^"]+)"/, 1]
end

task :version do
  puts version
end

task :test do
  $:.unshift './test'
  require File.basename('test/tests.rb')
end

task :default => :test