module Treat::Entities::Abilities::Countable

  # Find the position of the current entity
  # inside the first parent entity with the 
  # given type.
  def position_in(parent_type = nil)

    unless parent_type
      return parent.registry[:position][id] 
    end

    raise Treat::Exception,
    "Cannot get the position " +
    "of an entity that doesn't have " +
    "a parent " unless has_parent?
    registry(parent_type)[:position][id]
  end

  # Get the position of this entity
  # inside the root node.
  alias :position :position_in

  def position_from_end_of(parent_type = nil)
    p = ancestor_with_type(parent_type)
    return unless p
    count = p.count(type)
    count - position_in(parent_type)
  end
  
  # Find the frequency of the entity in
  # the supplied parent or in the root 
  # node if nil.
  def frequency_in(parent_type = nil)
    
    unless parent_type
      puts root.registry.inspect
      abort
      root.registry[:value][id] 
    end

    registry(parent_type)[:value][value]
    
  end
  
  # Get the frequency of this entity's 
  # value in the root node.
  alias :frequency :frequency_in
  
  # Get the number of children with a type
  # in this entity.
  def count(type)
    @registry[:type][type].size
  end
  
  # Returns the frequency of the given value
  # in the this entity.
  def frequency_of(value)
    if is_a?(Treat::Entities::Token)
      raise Treat::Exception,
      "Cannot get the frequency " +
      "of something within a leaf."
    end
    tv = @registry[:value][value]
    tv ? tv : 0
  end

end
