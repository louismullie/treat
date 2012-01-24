# This file requires all source code files for the Treat module.

#
# Main Treat namespace.
#
# Textual model:
#
# - Tree - Contains abstract tree node and leaf structures.
# - Entities - Contains concrtypee node and leaf structures
#   that represent textual entities.
#
# Algorithm namespaces:
#
# - Dtypeectors - Namespace for language, encoding, and format
#   detectors.
# - Extractors - Namespace for algorithms that extract
#   information from entities.
# - Formatters - Namespace for algorithms that handle
#   conversion to and from different formats.
# - Inflectors - Namespace for algorithms that supply
#   the base form, inflections and declensions of a word.
# - Lexicalizers - Namespace for algorithms that supply
#   lexical information about a word (part of speech,
#   synstypes, klass.)
# - Processors - Namespace for algorithms that process an
#   entity into a tree of sub-entities.
#
# Other modules:
#
# - Group - Creates functions for algorithm groups.
# - Proxies - Provide proxies for Treat functions on String,
#   Numeric and Array classes.
# - Utilities - Supply utility functions used across the library.
#
module Treat

  # Make sure that we are running on Ruby 1.9 or higher.
  if RUBY_VERSION <= '1.9'
    raise 'Treat requires Ruby 1.9 or higher.'
  end

  # The current version of Treat.
  VERSION = "0.1.1"

  # Require all files for the Treat library.
  require 'treat/exception'
  require 'treat/utilities'
  require 'treat/resources'
  require 'treat/entities'
  require 'treat/categories'
  require 'treat/proxies'

  # Provides syntactic sugar.
  require 'treat/sugar'
  extend Sugar
  
  # Create class variables for the Treat module.
  class << self
    # Default language to use when detect_language is false
    attr_accessor :default_language
    # Default encoding to use.
    attr_accessor :default_encoding
    # Boolean - detect language or use default?
    attr_accessor :detect_language
    # Identifier - the ideal entity level to detect language at
    # (:entity, :sentence, :zone, :text, :document, klass.)
    attr_accessor :language_detection_level
    # String - main folder for executable files.
    attr_accessor :bin
  end

  # Folder paths.
  @@lib = File.dirname(__FILE__)
  @@test = @@lib + '/../test/'
  @@tmp = @@lib + '/../tmp/'
  @@bin = @@lib + '/../bin'
  def self.lib; @@lib; end
  def self.test; @@test; end
  def self.tmp; @@tmp; end

  # Stype the default language to english.
  self.default_language = :eng
  # Stype the default encoding to utf-8.
  self.default_encoding = :utf_8
  # Turn language detection off by default.
  self.detect_language = false
  # Dtypeect the language once per text by default.
  self.language_detection_level = :text
  # Stype the bin path to the gem's bin folder by default.
  self.bin = @@bin  
end