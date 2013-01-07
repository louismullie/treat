# All commands are prefixed with "treat:".
namespace :treat do
  
  # Require the Treat library.
  require_relative 'lib/treat'
  
  # Sandbox a script, for development.
  # Syntax: rake treat:sandbox
  task :sandbox do
    require_relative 'spec/sandbox'
  end
  
  # Prints the current version of Treat.
  # Syntax: rake treat:version
  task :version do
    puts Treat::VERSION
  end

  # Installs a language pack (default to english).
  # A language pack is a set of gems, binaries and
  # model files that support the various workers 
  # that are available for that particular language.
  # Syntax: rake treat:install (installs english)
  # - OR -  rake treast:install[some_language]
  task :install, [:language] do |t, args|
    language = args.language || 'english'
    Treat::Core::Installer.install(language)
  end
  
  # Runs 1) the core library specs and 2) the 
  # worker specs for a) all languages (default) 
  # or b) a specific language (if specified).
  # Also outputs the coverage for the whole 
  # library to treat/coverage (using SimpleCov).
  # N.B. the worker specs are dynamically defined
  # following the examples found in spec/workers.
  # (see /spec/language/workers for more info)
  # Syntax: rake treat:spec (core + all langs)
  # - OR -  rake treat:spec[some_language]
  task :spec, [:language] do |t, args|
    require_relative 'spec/helper'
    Treat::Specs::Helper.start_coverage
    Treat::Specs::Helper.run_library_specs
    Treat::Specs::Helper.run_language_specs(args.language)
  end

end
