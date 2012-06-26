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
  
  s.post_install_message = 
  "********************************************************************************\n\n" +
  "Thank you for installing Treat!\n\n" +
  "Complete the installation by running:\n\n" +
  "    require 'treat'\n" +
  "    Treat.install\n\n" +
  "inside IRB or a Ruby script.\n\n" +
  "********************************************************************************\n\n"
  
  # Runtime dependencies
  s.add_runtime_dependency 'schiphol'
  
end