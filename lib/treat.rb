# encoding: utf-8
# Main namespace for Treat modules.
#
# === Entities
#
# Entities are Tree structures that represent textual entities
# (from a collection of texts down to an individual word), with
# a value, features, children and edges linking it to other
# textual entities.
#
# Here are some example of how to create entities:
#
#     c = Collection 'folder_with_documents'
#     d = Document 'filename.txt' # (or pdf, html, xml, doc, abw, odt, png, jpg, jpeg, gif).
#     p = Paragraph 'A short story. The end.'
#     s = Sentence 'That is not a sentence.'
#     w = Word 'fox'
#
# Here is a list of entities and their description:
#
#  - A Collection represents a folder with different textual documents.
#  - A Document represents a file with a textual content.
#  - A Section represents a logical subdivision of a document.
#  - A Zone can be a Title, a Paragraph or a List and represents an intra-section division of content.
#  - A Sentence represents just that.
#  - A Constituent can be a Phrase or a Clause and represents a syntactical unit.
#  - A Token can be a Word, a Number, a Punctuation or a Symbol (non-punctuation, non-alphanumeric characters).
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
# A worker class is defined for each implemented algorithm performing a given
# task. These classes are clustered into workers performing the same given task
# differently (Group), and the groups are clustered into Categories
# of groups of workers that perform related tasks.
#
# Here are the different Categories and their description:
#
#  - Processors perform the building of tree of entities representing texts (chunking, segmenting, tokenizing, parsing).
#  - Lexicalizers give lexical information about words (synsets, tag, word category).
#  - Extractors extract semantic information about an entity (topic, date, time, named entity).
#  - Inflectors allow to retrieve the different inflections of a word (declensors, conjugators, stemmers, lemmatizers).
#  - Formatters handle the conversion of entities to and from different formats (readers, serializers, unserializers, visualizers).
#
# === Linguistic Resources
#
# The Languages module contains linguistic information about
# languages (full ISO-639-1 and 2 language list, tag alignments
# for three treebanks, word categories, etc.)
#
# === Mixins for Entities
#
# Buildable, Delegatable, Visitable and Registrable are
# or extended by Entity and provide it with the ability to be built,
# to delegate function calls, to accept visitors and to maintain a
# token registry, respectively.
#
# === Exception Class.
#
# Treat::Exception defines a custom exception class for the Treat module.
#
module Treat

  # Make sure that we are running on Ruby 1.9 or higher.
  if RUBY_VERSION <= '1.9'
    raise 'Treat requires Ruby 1.9 or higher.'
  end

  # The current version of Treat.
  VERSION = "0.1.5"

  $LOAD_PATH << '/ruby/gems/treat/lib/' # Remove for release

  # Create class variables for the Treat module.
  class << self
    # Boolean - output debug information.
    attr_accessor :debug
    # Symbol - default language to use when detect_language is false.
    attr_accessor :default_language
    # Symbol - default encoding to use.
    attr_accessor :default_encoding
    # Boolean - detect language or use default?
    attr_accessor :detect_language
    # Symbol - the ideal entity level to detect language at
    # (e.g., :entity, :sentence, :zone, :section, :document)
    attr_accessor :language_detection_level
    # Array - a list of languages to bias towards if two languages
    # are detected with equal probability.
    attr_accessor :language_detection_bias
    # String - main folder for executable files.
    attr_accessor :bin
    # String - folder of this file.
    attr_accessor :lib
    # String - folder for tests.
    attr_accessor :test
  end

  # Turn off debug by default.
  self.debug = false
  # Set the default language to english.
  self.default_language = :eng
  # Set the default encoding to utf-8.
  self.default_encoding = :utf_8
  # Turn language detection off by default.
  self.detect_language = false
  # Detect the language once per text by default.
  self.language_detection_level = :zone
  # Languages to bias toward when more than one
  # language is detected with equal probability.
  self.language_detection_bias = [:eng, :fre, :chi, :ger, :ara, :esp]
  # Set the lib path to that of this file.
  self.lib = File.dirname(__FILE__)
  # Set the paths to the bin folder.
  self.bin = self.lib + '/../bin'
  # Set the paths to the test folder.
  self.test = self.lib + '/../test'

  # Require inline C
  # require 'inline'

  # Require modified core classes.
  require 'treat/object'
  require 'treat/kernel'

  # Require all files for the Treat library.
  require 'treat/exception'
  require 'treat/languages'
  require 'treat/entities'
  require 'treat/categories'
  require 'treat/proxies'
  require 'treat/sugar'

  # Make sugar available when needed.
  extend Treat::Sugar

  def self.install(language)
    require 'treat/install'
    Treat::Installer.install(language)
  end
  
end

#Treat.install(:english)