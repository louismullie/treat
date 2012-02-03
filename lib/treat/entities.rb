module Treat
  # Abstract and concrete structures extending the
  # Tree::Node class to represent textual entities:
  #
  # - Collection
  # - Document
  # - Zone (a Section, Title, Paragraph, or List)
  # - Sentence
  # - Phrases
  # - Token (a Word, Number, Punctuation, or Symbol).
  module Entities
    # Cache a list of defined entity types to
    # improve performance.
    @@list = nil
    # Provide a list of defined entity types,
    # as non-camel case identifiers.
    def self.list
      return @@list if @@list
      @@list = []
      self.constants.each do |constant|
        unless constant == :Entity
          @@list << ucc(constant).intern 
        end
      end
      @@list
    end
    # Require Entity first.
    require 'treat/entities/entity'
    # Then require all possible entities.
    require 'treat/entities/collection'
    require 'treat/entities/document'
    require 'treat/entities/zones'
    require 'treat/entities/phrases'
    require 'treat/entities/tokens'
    # Make the constants buildable.
    constants.each do |entity|
      define_singleton_method(entity) do |value='', id=nil|
        const_get(entity).build(value, id)
      end
    end
    # Create entity lookup table.
    # Lookup table
    @@match_types = nil
    def self.match_types
      return @@match_types if @@match_types
      list = (Treat::Entities.list + [:entity])
      @@match_types = {}
      list.each do |type1|
        @@match_types[type1] = {type1 => true}
        list.each do |type2|
          if Treat::Entities.const_get(cc(type1)) <
            Treat::Entities.const_get(cc(type2))
            @@match_types[type1][type2] = true
          end
        end
      end
      @@match_types
    end
    # Return the hierarchy level of the entity
    # class, the minimum being a Token and the
    # maximum being a Collection.
    def self.rank(type)
      klass = Entities.const_get(cc(type))
      compare = lambda { |a,b| a == b || a < b }
      return 0 if compare.call(klass, Token)
      return 1 if compare.call(klass, Phrase)
      return 2 if compare.call(klass, Sentence)
      return 3 if compare.call(klass, Zone)
      return 4 if compare.call(klass, Document)
      return 5 if compare.call(klass, Collection)
    end
  end
end
