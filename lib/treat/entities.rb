module Treat
  # Abstract and concrete structures extending the
  # Tree::Node class to represent textual entities:
  #
  # - Collection
  # - Document
  # - Text
  # - Zone (a Section, Title, Paragraph, or List)
  # - Sentence
  # - Constituent (a Phrase or Clause)
  # - Token (a Word, Number, Punctuation, or Symbol).
  module Entities
    # Require Entity first, since the other classes
    # extend this class.
    require 'treat/entities/entity'
    require 'treat/entities/collection'
    require 'treat/entities/document'
    require 'treat/entities/text'
    require 'treat/entities/zones'
    require 'treat/entities/sentence'
    require 'treat/entities/constituents'
    require 'treat/entities/tokens'
    # Make the constants buildable.
    constants.each do |entity|
      define_singleton_method(entity) do |value='', id=nil|
        const_get(entity).build(value, id)
      end
    end
    # Provide a list of defined entity types,
    # as non-camel case identifiers.
    @@list = []
    def self.list
      return @@list unless @@list.empty?
      self.constants.each do |constant|
        @@list << :"#{ucc(constant)}"
      end
      @@list
    end
    # Return the 'z-order' for hierarchical
    # comparison of entity types.
    def self.rank(type)
      klass = Entities.const_get(cc(type))
      return 6 if klass == Collection || klass < Collection
      return 5 if klass == Document || klass < Document
      return 4 if klass == Text || klass < Text
      return 3 if klass == Zone || klass < Zone
      return 2 if klass == Sentence || klass < Sentence
      return 1 if klass == Constituent || klass < Constituent
      return 0 if klass == Token || klass < Token
    end
  end
end
