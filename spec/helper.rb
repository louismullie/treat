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

require_relative '../lib/treat'
=begin
Treat.core.language.detect = true
Treat.core.verbosity.debug = true
Treat.paths.files = './files/'
Treat.databases.mongo.db = 'gistify'
Treat.databases.default.adapter = :mongo
Treat.libraries.stanford.model_path = 
'/ruby/stanford/stanford-core-nlp-all/'
Treat.libraries.stanford.jar_path =
'/ruby/stanford/stanford-core-nlp-all/'
Treat.libraries.punkt.model_path = 
'/ruby/punkt/'
Treat.libraries.reuters.model_path =
'/ruby/reuters/'
=end