# -*- encoding: utf-8 -*-
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
  s.files = Dir['lib/**/*'] + Dir['test/**/*'] + Dir['examples/**/*'] +
  Dir['bin/**/*'] + Dir['tmp/**/*'] + ['README', 'TODO', 'LICENSE', 'INSTALL']
  
  # Runtime dependencies
  s.add_runtime_dependency 'rjb'
  s.add_runtime_dependency 'nokogiri'
  s.add_runtime_dependency 'chronic'
  s.add_runtime_dependency 'hpricot'
  s.add_runtime_dependency 'psych'
  s.add_runtime_dependency 'rchardet19'
  s.add_runtime_dependency 'whatlanguage'
  s.add_runtime_dependency 'wordnet'
  s.add_runtime_dependency 'rbtagger'
  s.add_runtime_dependency 'engtagger'
  s.add_runtime_dependency 'punkt-segmenter'
  s.add_runtime_dependency 'tokenizer'
  s.add_runtime_dependency 'tactful_tokenizer'
  s.add_runtime_dependency 'english'
  s.add_runtime_dependency 'linguistics'
  s.add_runtime_dependency 'ruby-stemmer'
  s.add_runtime_dependency 'uea-stemmer'
  s.add_runtime_dependency 'lda-ruby'
  s.add_runtime_dependency 'nickel'
    
  # Development dependencies.
  s.add_development_dependency 'unprof'
    
end
