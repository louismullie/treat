module Treat::Entities::Abilities::Countable

  # Find the position of the current entity
  # inside the parent entity.
  def position_in(parent_type = nil)
    unless parent_type
      return @registry[:position][id] 
    end
    raise Treat::Exception,
    "Cannot get the position " +
    "of an entity that doesn't have " +
    "a parent " unless has_parent?
    registry(parent_type)[:position][id]
  end

  # Get the position of this entity
  # inside the root node.
  def position
    position_in(:root)
  end
  
  # Find the frequency of the entity in
  # the supplied parent.
  def frequency_in(parent_type = nil)
    unless parent_type
      return @registry[:value][id] 
    end
    registry(parent_type)[:value][value]
  end
  
  # Get the frequency of this entity's 
  # value in the root node.
  def frequency
    frequency_in(:root)
  end
  
  # Returns the frequency of the given value
  # in the this entity.
  def frequency_of(value)
    unless has_children?
      raise Treat::Exception,
      "Cannot get the frequency " +
      "of something within a leaf."
    end
    tv = @registry[:value][value]
    tv ? tv : 0
  end

end
