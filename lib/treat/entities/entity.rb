module Treat::Entities

  # Require base class for Entity.
  require 'treat/tree'

  class Entity < Treat::Tree::Node

    # A Symbol representing the lowercase
    # version of the class name.
    attr_accessor :type

    # Require abilities.
    require 'treat/entities/abilities'

    # Implements support for #register
    # and #token_registry.
    include Abilities::Registrable

    # Implement support for #accept.
    include Abilities::Visitable

    # Implement support for #self.add_workers
    extend Abilities::Delegatable

    # Implement support for #build and #self.from_*
    extend Abilities::Buildable

    # Implement support for #do.
    include Abilities::Doable

    # Implement support for #frequency,
    # #frequency_in_parent and #position_in_parent.
    include Abilities::Countable

    # Implement support for #magic.
    include Abilities::Magical
    
    # Implement support for to_s, inspect, etc.
    include Abilities::Viewable

    # Implement support for #each_entity, as well as
    # #entities_with_type, #ancestors_with_type,
    # #entities_with_feature, #entities_with_category.
    include Abilities::Iterable


    # Initialize the entity with its value and
    # (optionally) a unique identifier. By default,
    # the object_id will be used as id.
    def initialize(value = '', id = nil)
      id ||= object_id
      super(value, id)
      @type = :entity if self == Entity
      @type ||= ucc(cl(self.class)).intern
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
          get_error_msg(sym)
        end
      else
        @features[sym]
      end
      
    end
    
    # Add an entity to the current entity.
    # Registers the entity in the root node
    # token registry if the entity is a leaf.
    #
    # @see Treat::Registrable
    def <<(entities, clear_parent = true)
      entities = [entities] unless entities.is_a? Array
      entities.each do |entity|
        if entity.is_a?(Treat::Entities::Token) ||
          entity.is_a?(Treat::Entities::Phrase)
          register_token(entity) unless entity.value == ''
        end
      end
      super(entities)
      @parent.value = '' if has_parent?
      entities[0]
    end
    
    private

    # Lookup if a handler method is available for the
    # supplied symbol.
    def get_error_msg(sym)
      if Treat::Categories.lookup(sym)
        msg = "Method #{sym} cannot " +
        "be called on a #{type}."
      else
        msg = "Method #{sym} does not exist."
        msg += did_you_mean?(
        Treat::Categories.methods, sym)
      end
    end
    
  end
  
end