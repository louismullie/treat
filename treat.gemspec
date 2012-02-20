$:.push File.expand_path('../lib', __FILE__)

require 'treat'

Gem::Specification.new do |s|
  
  s.name        = 'treat'
  s.version     = Treat::VERSION
  s.authors     = ['Louis Mullie']
  s.email       = ['louis.mullie@gmail.com']
  s.homepage    = 'https://github.com/louismullie/treat'
  s.summary     = %q{ Text retrieval, extraction and annotation toolkit }
  s.description = %q{ Treat is a toolkit for text retrieval, information extraction and natural language processing. }
  
  # Add all files.
  s.files = Dir['lib/**/*'] + Dir['test/**/*'] + Dir['tmp/**/*'] + 
  ['README', 'TODO', 'LICENSE', 'INSTALL']
  
  # Runtime dependencies
  s.add_runtime_dependency 'psych', '>= 1.2.2'
  s.add_runtime_dependency 'nokogiri', '>= 1.5.0'
  s.add_runtime_dependency 'sdsykes-ferret', '>= 0.11.6.19'
  s.add_runtime_dependency 'lda-ruby', '>= 0.3.8'
  s.add_runtime_dependency 'zip', '>= 2.0.2'
  s.add_runtime_dependency 'ruby-readability', '>= 0.5.0'
  s.add_runtime_dependency 'stanford-core-nlp', '>= 0.1.6'
  s.add_runtime_dependency 'whatlanguage', '>= 1.0.0'
  s.add_runtime_dependency 'linguistics', '>= 1.0.9'
  s.add_runtime_dependency 'punkt-segmenter', '>= 0.9.1'
  s.add_runtime_dependency 'chronic', '>= 0.6.7'
  
end
