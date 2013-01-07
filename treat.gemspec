$:.push File.expand_path('../lib', __FILE__)

require 'treat/version'

Gem::Specification.new do |s|
  
  s.name        = 'treat'
  s.version     = Treat::VERSION
  s.authors     = ['Louis Mullie']
  s.email       = ['louis.mullie@gmail.com']
  s.homepage    = 'https://github.com/louismullie/treat'
  s.summary     = %q{ Text Retrieval, Extraction and Annotation Toolkit. }
  s.description = %q{ Treat is a natural language processing framework for Ruby. }
  
  # Add all files.
  s.files = 
  Dir['bin/**/*'] + 
  Dir['lib/**/*'] + 
  Dir['spec/**/*'] +
  Dir['models/**/*'] +  
  Dir['tmp/**/*'] + 
  Dir['files/**/*'] +
  ['README.md', 'LICENSE']
  
  # Runtime dependencies
  s.add_runtime_dependency 'schiphol'
  s.add_runtime_dependency 'birch'
  
  # Development dependencies
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'simplecov'
  
  # Post-install message
  s.post_install_message = %q{Thanks for installing Treat.
  To complete the installation, run `require treat` in an IRB 
  terminal, followed by `Treat::Core::Installer.install`. }

end