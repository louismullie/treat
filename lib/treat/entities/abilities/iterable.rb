module Treat::Entities::Abilities::Iterable

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
      if Treat::Entities.match_types[t2][type]
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
      a << e if (e.has?(feature) &&
      e.features[feature] == value) ||
      ([:id, :value, :type].include?(feature) &&
      e.send(feature) == value)
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
    entities_with_feature(:category, type)
  end
  
  # Returns the first ancestor of this entity 
  # that has the given type.
  def ancestor_with_types(*types)
    ancestor = @parent
    match_types = lambda do |t1, t2|
      f = false
      types.each do |t2|
        if Treat::Entities.match_types[t2][t1]
          f = true; break
        end
      end
      f
    end
    if ancestor
      while not match_types.call(ancestor.type, type)
        return nil unless (ancestor && ancestor.has_parent?)
        ancestor = ancestor.parent
      end
      match_types.call(ancestor.type, types) ? ancestor : nil
    end
  end

  alias :ancestor_with_type :ancestor_with_types

  # Yields each ancestors of this entity that
  # has one of the the given types. May skip levels.
  def each_ancestor(*types)
    types = [:entity] if types.empty?
    ancestor = self
    while (a = ancestor.ancestor_with_types(*types))
      yield a
      ancestor = ancestor.parent
    end
  end
  
  # Returns an array of ancestors of this entity that
  # has one of the the given types. May skip levels.
  def ancestors_with_types(*types)
    as = []
    each_ancestor(*types) { |a| as << a }
    as
  end

  alias :ancestors_with_type :ancestors_with_types

  # Number of children that have a given feature.
  def num_children_with_feature(feature)
    i = 0
    each do |c| 
      i += 1 if c.has?(feature)
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