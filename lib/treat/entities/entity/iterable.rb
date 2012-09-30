module Treat::Entities::Entity::Iterable

  # Yields each entity of any of the supplied
  # types in the children tree of this Entity.
  # Note that this function is recursive, unlike
  # #each. It does not yield the top element being
  # recursed.
  #
  # This function NEEDS to be ported to C.
  def each_entity(*types)
    types = [:entity] if types.size == 0
    f = false
    types.each do |t2|
      if is_a?(Treat::Entities.const_get(cc(t2)))
        f = true; break
      end
    end
    yield self if f
    unless @children.size == 0
      # return unless contains_types?(types)
      @children.each do |child|
        child.each_entity(*types) { |y| yield y }
      end
    end
  end

  # Returns an array of the children that have a feature
  # equal to value within the entities of the given type.
  def entities_with_feature(feature, value, type = nil)
    a = []
    type = :entity unless type
    each_entity(type) do |e|
      r = e.get(feature)
      a << e if r == value
    end
    a
  end
  
  # Returns an array of the children that have a type
  # within the supplied types.
  def entities_with_types(*types)
    a = []
    each_entity(*types) { |e| a << e }
    a
  end
  
  alias :entities_with_type :entities_with_types
  
  # Returns an array of the entities with the given
  # category.
  def entities_with_category(category, type = nil)
    entities_with_feature(:category, category, type)
  end
  
  # Returns the first ancestor of this entity 
  # that has the given type.
  def ancestor_with_type(type)
    return unless has_parent?
    ancestor = @parent
    type_klass = Treat::Entities.const_get(cc(type))
    while not ancestor.is_a?(type_klass)
      return nil unless (ancestor && ancestor.has_parent?)
      ancestor = ancestor.parent
    end
    ancestor
  end

  # Yields each ancestors of this entity that
  # has the given type.
  def each_ancestor(type = :entity)
    ancestor = self
    while (a = ancestor.ancestor_with_type(type))
      yield a
      ancestor = ancestor.parent
    end
  end
  
  # Returns an array of ancestors of this 
  # entity that have the given type.
  def ancestors_with_type(type)
    ancestors = []
    each_ancestor(type) do |a| 
      ancestors << a
    end
    ancestors
  end

  # Returns the first ancestor that has a feature
  # with the given name, otherwise nil.
  def ancestor_with_feature(feature)
    each_ancestor do |ancestor|
      return ancestor if ancestor.has?(feature)
    end
  end
  
  # Number of children that have a given feature.
  # Second variable to allow for passing value to check for.
  def num_children_with_feature(feature, value = nil, recursive = true)
    i = 0
    m = method(recursive ? :each_entity : :each)
    m.call do |c|
      next unless c.has?(feature)
      i += (value == nil ? 1 : 
      (c.get(feature) == value ? 1 : 0))
    end
    i
  end
  
  # Return the first element in the array, warning if not
  # the only one in the array. Used for magic methods: e.g.,
  # the magic method "word" if called on a sentence with many 
  # words, Treat will return the first word, but warn the user.
  def first_but_warn(array, type)
    if array.size > 1
      warn "Warning: requested one #{type}, but" +
      " there are many #{type}s in this entity."
    end
    array[0]
  end

  
end