$:.unshift File.join(File.dirname(__FILE__), "..", "lib")

require 'treat'
require 'texts'

# This is roughly in order of dependence.
require 'treat'
require 'tree'
require 'entity'
require 'resources'
require 'formatters'
require 'inflectors'
require 'lexicalizers'
require 'processors'
#require 'extractors'