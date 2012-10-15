module Treat::Entities

  # Basic tree structure.
  require 'birch'
  
  # The Entity class extends a basic tree structure 
  # (written in C for optimal speed) and represents 
  # any form of textual entityin a processing task 
  # (this could be a collection of documents, a 
  # single document, a single paragraph, etc.)
  # 
  # Classes that extend Entity provide the concrete
  # behavior corresponding to the relevant entity type. 
  # See entities.rb for a full list and description of 
  # the different entity types in the document model.
  class Entity < ::Birch::Tree

    # A symbol representing the lowercase
    # version of the class name. This is 
    # the only attribute that the Entity
    # class adds to the Birch::Tree class.
    attr_accessor :type
    
    # Autoload all the classes in /abilities.
    include Treat::Autoload
    
    # Implements support for #register, #registry.
    include Registrable

    # Implement support for #self.call_worker, etc.
    extend Delegatable

    # Implement support for #self.print_debug, etc.
    extend Debuggable

    # Implement support for #self.build and #self.from_*
    extend Buildable

    # Implement support for #apply (previously #do).
    include Applicable

    # Implement support for #frequency, #frequency_in,
    # #frequency_of, #position, #position_from_end, etc.
    include Countable

    # Implement support for over 100 #magic methods!
    include Magical

    # Implement support for #to_s, #inspect, etc.
    include Stringable

    # Implement support for #check_has and others.
    include Checkable

    # Implement support for #each_entity, as well as
    # #entities_with_type, #ancestors_with_type,
    # #entities_with_feature, #entities_with_category, etc.
    include Iterable

    # Implement support for #export, allowing to export 
    # a data set row from the receiving entity.
    include Exportable

    # Implement support for #self.compare_with
    extend Comparable

    # Initialize the entity with its value and
    # (optionally) a unique identifier. By default,
    # the object_id will be used as id.
    def initialize(value = '', id = nil)
      id ||= object_id; super(value, id)
      @type = :entity if self == Entity
      @type ||= self.class.mn.ucc.intern
    end

    # Add an entity to the current entity.
    # Registers the entity in the root node
    # token registry if the entity is a leaf.
    # Unsets the parent node's value; in order
    # to keep the tree clean, only the leaf
    # values are stored.
    # 
    # Takes in a single entity or an array of 
    # entities. Returns the first child supplied.
    # @see Treat::Registrable
    def <<(entities, clear_parent = true)
      entities = entities.is_a?(::Array) ?
      entities : [entities]
      # Register each entity in this node.
      entities.each { |e| register(e) }
      # Pass to the <<() method in Birch.
      super(entities)
      # Unset the parent value if necessary.
      @parent.value = '' if has_parent?
      # Return the first child.
      return entities[0]
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
      return @features[sym] if @features.has_key?(sym)
      result = magic(sym, *args, &block)
      return result unless result == :no_magic
      begin; super(sym, *args, &block)
      rescue NoMethodError; invalid_call(sym); end
    end
    
    # Raises a Treat::Exception saying that the 
    # method called was invalid, and that the 
    # requested method does not exist. Also
    # provides suggestions for misspellings.
    def invalid_call(sym)
      msg = Treat::Workers::Category.lookup(sym) ?
      "Method #{sym} can't be called on a #{type}." :
      "Method #{sym} is not defined by Treat." +
      Treat::Helpers::Help.did_you_mean?(
      Treat::Workers.methods, sym)
      raise Treat::Exception, msg
    end
    
  end

end
