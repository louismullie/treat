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
  s.add_runtime_dependency 'psych'
  s.add_runtime_dependency 'nokogiri'
  s.add_runtime_dependency 'hpricot'
  s.add_runtime_dependency 'sdsykes-ferret'
  s.add_runtime_dependency 'lda-ruby'
  s.add_runtime_dependency 'stanford-core-nlp'
  s.add_runtime_dependency 'whatlanguage'
  s.add_runtime_dependency 'linguistics'
  s.add_runtime_dependency 'punkt-segmenter'
  s.add_runtime_dependency 'chronic'
  s.add_runtime_dependency 'zip'
  
end
