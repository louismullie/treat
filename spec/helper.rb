module Treat::Spec
  ### Initialize SimpleCov
  require 'simplecov'

  SimpleCov.start do

    add_filter '/spec/'
    add_filter '/config/'

    add_group 'Core', 'treat/core'
    add_group 'Entities', 'treat/entities'
    add_group 'Helpers', 'treat/helpers'
    add_group 'Loaders', 'treat/loaders'
    add_group 'Workers', 'treat/workers'
    add_group 'Config', 'config.rb'
    add_group 'Proxies', 'proxies.rb'
    add_group 'Treat', 'treat.rb'

  end

  ### Require Treeat
  require_relative '../lib/treat'

  ### Set Defaults
=begin
Treat.core.language.detect = true
Treat.core.verbosity.debug = true
Treat.paths.files = './files/'
Treat.databases.mongo.db = 'gistify'
Treat.databases.default.adapter = :mongo
=end

  Treat.libraries.stanford.model_path =
  '/ruby/stanford/stanford-core-nlp-all/'
  Treat.libraries.stanford.jar_path =
  '/ruby/stanford/stanford-core-nlp-all/'
  Treat.libraries.punkt.model_path =
  '/ruby/punkt/'
  Treat.libraries.reuters.model_path =
  '/ruby/reuters/'


  ### Require benchmarks and run them all.
  require_relative 'languages/benchmark'
  Dir.glob(Treat.paths.spec + 'languages/*.rb').each do |file|
    require file
  end
  Treat::Spec::Languages.constants.each do |cst|
    next if cst == :Benchmark
    Treat::Spec::Languages.const_get(cst).new.run :specs
  end

end
