module Treat::Entities

  module Abilities; end

  # Require abilities.
  p = Treat.paths.lib +
  'treat/entities/abilities/*.rb'
  Dir.glob(p).each { |f| require f }

  require 'birch'

  class Entity < ::Birch::Tree

    # A Symbol representing the lowercase
    # version of the class name.
    attr_accessor :type

    # Implements support for #register,
    # #registry, and #contains_* methods.
    include Abilities::Registrable

    # Implement support for #self.add_workers
    extend Abilities::Delegatable

    # Implement support for #self.print_debug and
    # #self.invalid_call_msg
    extend Abilities::Debuggable

    # Implement support for #self.build
    # and #self.from_*
    extend Abilities::Buildable

    # Implement support for #chain.
    include Abilities::Chainable

    # Implement support for #frequency,
    # #frequency_in_parent and #position_in_parent.
    include Abilities::Countable

    # Implement support for #magic.
    include Abilities::Magical

    # Implement support for #to_s, #inspect, etc.
    include Abilities::Stringable

    # Implement support for #check_has
    # and #check_hasnt_children?
    include Abilities::Checkable

    # Implement support for #each_entity, as well as
    # #entities_with_type, #ancestors_with_type,
    # #entities_with_feature, #entities_with_category.
    include Abilities::Iterable

    # Implement support for #export to export
    # a line of a data set based on a classification.
    include Abilities::Exportable

    # Implement support for #copy_into.
    include Abilities::Copyable

    # Implement support for #self.compare_with
    extend Abilities::Comparable

    # Initialize the entity with its value and
    # (optionally) a unique identifier. By default,
    # the object_id will be used as id.
    def initialize(value = '', id = nil)
      id ||= object_id
      super(value, id)
      @type = :entity if self == Entity
      @type ||= ucc(cl(self.class)).intern
    end

    # Add an entity to the current entity.
    # Registers the entity in the root node
    # token registry if the entity is a leaf.
    #
    # @see Treat::Registrable
    def <<(entities, clear_parent = true)
      unless entities.is_a? Array
        entities = [entities]
      end
      entities.each do |entity|
        register(entity)
      end
      super(entities)
      @parent.value = '' if has_parent?
      entities[0]
    end

    # Catch missing methods to support method-like
    # access to features (e.g. entity.category
    # instead of entity.features[:category]) and to
    # support magic methods (see #magic).
    #
    # If the feature or magic method does not exist,
    # or can't be parsed, raises an exception.
    #
    # Also catches the "empty" method call (e.g.
    # Word('hello') or Word 'hello') as syntactic
    # sugar for the #self.build method.
    def method_missing(sym, *args, &block)
      return self.build(*args) if sym == nil

      if !@features.has_key?(sym)
        r = magic(sym, *args, &block)
        return r unless r == :no_magic
        begin
          super(sym, *args, &block)
        rescue NoMethodError
          raise Treat::Exception,
          if Treat::Workers.lookup(sym)
            msg = "Method #{sym} cannot " +
            "be called on a #{type}."
          else
            msg = "Method #{sym} does not exist."
            msg += did_you_mean?(
            Treat::Workers.methods, sym)
          end
        end
      else
        @features[sym]
      end

    end

  end

end
