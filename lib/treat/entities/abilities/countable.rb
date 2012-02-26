module Treat::Entities::Abilities::Countable

  # Find the position of the current entity
  # inside the parent entity.
  def position_in(parent_type = nil)
    raise Treat::Exception,
    "Cannot get the position " +
    "of an entity that doesn't have " +
    "a parent " unless has_parent?
    registry(parent_type)[:position][id]
  end

  # Get the position of this entity
  # inside the root node.
  alias :position :position_in
  
  # Find the frequency of the entity in
  # the supplied parent.
  def frequency_in(parent_type = nil)
    registry(parent_type)[:value][value]
  end
  
  # Get the frequency of this entity's 
  # value in the root node.
  alias :frequency :frequency_in
  
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
