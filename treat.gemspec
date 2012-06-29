$:.push File.expand_path('../lib', __FILE__)

require 'treat/version'

Gem::Specification.new do |s|
  
  s.name        = 'treat'
  s.version     = Treat::VERSION
  s.authors     = ['Louis Mullie']
  s.email       = ['louis.mullie@gmail.com']
  s.homepage    = 'https://github.com/louismullie/treat'
  s.summary     = %q{ Text Retrieval, Extraction and Annotation Toolkit. }
  s.description = %q{ Treat is a full-fledged natural language processing toolkit for Ruby. }
  
  # Add all files.
  s.files = 
  Dir['lib/**/*'] + 
  Dir['spec/**/*'] + 
  Dir['tmp/**/*'] + 
  Dir['files/**/*'] +
  ['README.md', 'LICENSE']
  
  # Runtime dependencies
  s.add_runtime_dependency 'schiphol'
  s.add_runtime_dependency 'psych'
  s.add_runtime_dependency 'nokogiri'
  s.add_runtime_dependency 'ferret'
  s.add_runtime_dependency 'mongo'
  s.add_runtime_dependency 'bson_ext'
  s.add_runtime_dependency 'lda-ruby'
  s.add_runtime_dependency 'stanford-core-nlp'
  s.add_runtime_dependency 'ruby-readability'
  s.add_runtime_dependency 'linguistics'
  s.add_runtime_dependency 'whatlanguage'
  s.add_runtime_dependency 'chronic'
  s.add_runtime_dependency 'nickel'
  s.add_runtime_dependency 'decisiontree'
  s.add_runtime_dependency 'ai4r'
  s.add_runtime_dependency 'rbtagger'
  s.add_runtime_dependency 'ruby-stemmer'
  s.add_runtime_dependency 'punkt-segmenter'
  s.add_runtime_dependency 'tactful_tokenizer'
  s.add_runtime_dependency 'nickel'
  s.add_runtime_dependency 'rwordnet'
  s.add_runtime_dependency 'uea-stemmer'
  s.add_runtime_dependency 'engtagger'
  s.add_runtime_dependency 'activesupport'
  s.add_runtime_dependency 'english'
  
  # Development dependencies
  s.add_development_dependency 'rspec'
  
end