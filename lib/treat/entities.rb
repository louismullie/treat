# Entities are Tree structures that represent textual entities
# (from a collection of texts down to an individual word) with
# a unique identifier, a value, features, children and dependencies
# linking them to other textual entities.
#
# - A Collection represents a folder containing documents (and folders).
# - A Document represents a file with a textual content.
# - A Zone represents a logical division of content in a document.
# - A Phrase is a group of words; a Sentence is a Phrase with an ender.
# - A Token represents a Word, a Number, a Punctuation or a Symbol.
module Treat::Entities

  # Variables for the singleton class.
  class << self
    # Provide a list of all entity types except Entity,
    # as non_camel_case identifiers.
    attr_accessor :list
  end

  # Require all entities.
  require 'treat/entities/entities'
  
  # Add each constant to the list, except Entity.
  self.list = []
  constants.each do |constant|
    unless constant == :Entity || 
           constant == :Abilities
      self.list << ucc(constant).intern
    end
  end

  # Make each Entity class buildable magically.
  # This enables to create Entities without calling
  # #new (e.g. Word 'hello').
  constants.each do |entity|
    define_singleton_method(entity) do |value='', id=nil|
      const_get(entity).build(value, id)
    end
  end

  # Create entity lookup table.
  @@match_types = nil
  def self.match_types
    return @@match_types if @@match_types
    list = (Treat::Entities.list + [:entity])
    @@match_types = {}
    list.each do |type1|
      list.each do |type2|
        @@match_types[type2] ||= {}
        if (type1 == type2) ||
          (Treat::Entities.const_get(cc(type1)) <
          Treat::Entities.const_get(cc(type2)))
          @@match_types[type2][type1] = true
        end
      end
    end
    @@match_types
  end
  
  # A bottom-up ordering of general types of entities.
  @@order = [Token, Fragment, Phrase, Sentence, Zone, Section, Document, Collection]
  
  # Return the hierarchy level of the entity
  # class, the minimum being a Token and the
  # maximum being a Collection.
  #
  # Implement as true comparison functions.
  def self.rank(type)
    klass = Treat::Entities.const_get(cc(type))
    compare = lambda { |a,b| a == b || a < b }
    1.upto(@@order.size) do |i|
      return i if compare.call(klass, @@order[i])
    end
  end

end
