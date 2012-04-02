$:.push File.expand_path('../lib', __FILE__)

require 'treat'

Gem::Specification.new do |s|
  
  s.name        = 'treat'
  s.version     = Treat::VERSION
  s.authors     = ['Louis Mullie']
  s.email       = ['louis.mullie@gmail.com']
  s.homepage    = 'https://github.com/louismullie/treat'
  s.summary     = %q{ A text retrieval, extraction and annotation toolkit for Ruby. }
  s.description = %q{ Treat is a Ruby toolkit for text retrieval, information extraction and natural language processing. }
  
  # Add all files.
  s.files = Dir['lib/**/*'] + Dir['spec/**/*'] + 
  Dir['tmp/**/*'] + Dir['files/**/*'] + Dir['bin/**/*'] +
  ['README.md', 'LICENSE']
  
  # Runtime dependencies
  s.add_runtime_dependency 'rubyzip', '>= 0.9.6.1'
  s.add_runtime_dependency 'progressbar', '>= 0.10.0'
  s.add_development_dependency 'rspec', '>= 2.9.0'
  s.add_development_dependency 'rake', '>= 0.9.2'
  
end