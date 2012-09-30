# Treat is a toolkit for natural language 
# processing and computational linguistics 
# in Ruby. The Treat project aims to build 
# a language- and algorithm- agnostic NLP 
# framework for Ruby with support for tasks 
# such as document retrieval, text chunking, 
# segmentation and tokenization, natural 
# language parsing, part-of-speech tagging, 
# keyword mining and named entity recognition.
#
# Author: Louis-Antoine Mullie (c) 2010-12.
# 
# Released under the General Public License.
module Treat
  
  # * Load all the core classes. * #
  require_relative 'treat/version'
  require_relative 'treat/exception'
  require_relative 'treat/modules'
  
  # * Enable syntactic sugar. * #
  Treat::Config.sweeten!
  
end
