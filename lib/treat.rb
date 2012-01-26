# Main namespace for Treat modules.
#
# === Entities
#
# Entities are Tree structures that represent any textual 
# entity (from a collection of texts down to an individual
# word) with a value, features, children and edges linking
# it to other textual entities. Sugar provides syntactic sugar
# for Entities and can be enabled by running Treat.edulcorate.
# 
# Here are some example of how to create entities:
#
#     c = Collection 'folder_with_documents'
#     d = Document 'filename.txt' # (or PDF, html, xml, png, jpg, gif).
#     p = Paragraph 'A short story. The end.'
#     s = Sentence 'That is not a sentence.'
#     w = Word 'fox'
#  
# Here's a full list of entities (subtypes in parentheses): 
# Collection, Document, Zone (Section, Title, Paragraph or List),
# Sentence, Constituent (Phrase or Clause), Token (Word, Number,
# Symbol or Punctuation).
# 
# === Proxies
# 
# Proxies allow the Treat functions to be called on the core
# Ruby classes String, Numeric and Array. They build the entity 
# corresponding to the supplied raw text and send the requested 
# function to it.
# 
# For example,
#
#     'fox'.tag
#
# Is equivalent to:
#
#     w = Word 'fox'
#     w.tag
# 
# === Functions
#
# A class is defined for each implemented algorithm performing a given
# task. These classes are clustered into groups of algorithms performing
# the same given task (Group), and the groups are clustered into Categories 
# of groups performing related tasks.
#
# Here are the different Categories:
# 
# - Detectors - Category for language, encoding, and format 
#   detectors.
# - Extractors - Category for algorithms that extract information 
#   from entities.
# - Formatters - Category for algorithms that handle conversion 
#   to and from different formats.
# - Inflectors - Category for algorithms that supply the base 
#   form, inflections and declensions of a word.
# - Lexicalizers - Category for algorithms that supply lexical 
#   information about a word (part of speech, synsets, word categories).
# - Processors - Namespace for algorithms that process collections and 
#   documents into trees.
#
# === Linguistic resources
# 
# The Languages module contains linguistic information about 
# languages (full ISO-639-1 and 2 language list, tag alignments 
# for three treebanks, word categories, etc.)
#  
# === Mixins for entities.
# 
# Buildable, Delegatable, Visitable and Registrable are
# or extended by Entity and provide it with the ability to be built, 
# to delegate function calls, to accept visitors and to maintain a 
# token registry, respectively.
#
# === Exception class.
#  
# Exception defines a custom exception class for the Treat module.
# 
module Treat

  # Make sure that we are running on Ruby 1.9 or higher.
  if RUBY_VERSION <= '1.9'
    raise 'Treat requires Ruby 1.9 or higher.'
  end
  
  # The current version of Treat.
  VERSION = "0.1.4"

  # $LOAD_PATH << '/ruby/treat/lib/' # Remove for release
  
  # Create class variables for the Treat module.
  class << self
    # Symbol - default language to use when detect_language is false.
    attr_accessor :default_language
    # Symbol - default encoding to use.
    attr_accessor :default_encoding
    # Boolean - detect language or use default?
    attr_accessor :detect_language
    # Symbol - the ideal entity level to detect language at
    # (e.g., :entity, :sentence, :zone, :section, :document)
    attr_accessor :language_detection_level
    # String - main folder for executable files.
    attr_accessor :bin
    # String - folder of this file.
    attr_accessor :lib
    # String - folder for tests.
    attr_accessor :test
  end

  # Set the default language to english.
  self.default_language = :eng
  # Set the default encoding to utf-8.
  self.default_encoding = :utf_8
  # Turn language detection off by default.
  self.detect_language = false
  # Detect the language once per text by default.
  self.language_detection_level = :section
  # Set the lib path to that of this file.
  self.lib = File.dirname(__FILE__)
  # Set the paths to the bin folder.
  self.bin = self.lib + '/../bin'
  # Set the paths to the test folder.
  self.test = self.lib + '/../test'

  # Require modified core classes.
  require 'treat/object'
  require 'treat/kernel'
  require 'treat/string'

  # Require all files for the Treat library.
  require 'treat/exception'
  require 'treat/languages'
  require 'treat/entities'
  require 'treat/categories'
  require 'treat/proxies'
  require 'treat/sugar'
  
  # Make sugar available when needed.
  extend Sugar
end