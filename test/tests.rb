require 'test/unit'

$:.unshift File.join(File.dirname(__FILE__), "..", "lib")

require 'treat'
require 'texts'

Treat.bin = '/ruby/nat/bin' # Remove

require 'tc_treat'
require 'tc_tree'
require 'tc_entity'
require 'tc_resources'

require 'tc_detectors'
require 'tc_formatters'
require 'tc_inflectors'
require 'tc_lexicalizers'
require 'tc_processors'
require 'tc_extractors'