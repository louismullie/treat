module Treat::Entities

  # Require the base tree node class.
  require 'treat/entities/node'
  # Require the base entity class.
  require 'treat/entities/entity'
  # Require all concrete entities.
  require 'treat/entities/entities'
  
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
  # Cache the list.
  @@list = nil
  def self.match_types
    return @@match_types if @@match_types
    @@list ||= (Treat.core.entities)
    @@match_types = {}
    @@list.each do |type1|
      @@list.each do |type2|
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
  
  # A bottom-up ordering of 
  # general types of entities.
  @@order = [
    Token, Fragment, Phrase, 
    Sentence, Zone, Section, 
    Document, Collection
  ]
  
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
