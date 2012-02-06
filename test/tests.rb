require 'test/unit'

$:.unshift File.join(File.dirname(__FILE__), "..", "lib")

require 'treat'

#$LOAD_PATH << '/ruby/gems/treat/test' # Remove for release

require 'texts'

# This is roughly in order of dependence.
require 'tc_treat'
require 'tc_tree'
require 'tc_entity'
require 'tc_resources'
require 'tc_formatters'
require 'tc_inflectors'
require 'tc_lexicalizers'
require 'tc_processors'
#require 'tc_extractors'