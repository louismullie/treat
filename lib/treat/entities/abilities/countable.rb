module Treat::Entities::Abilities::Countable

  # Find the position of the current entity
  # inside the parent entity, starting at 1.
  def position
    unless has_parent?
      raise Treat::Exception,
      "No parent to get position in."
    end
    parent.children.index(self) + 1
  end

  # Find the position of this entity from
  # the end of the parent entity.
  def position_from_end
    p = position
    parent.children.size - p
  end
  
  # Find the frequency of the entity in
  # the supplied parent or in the root
  # node if nil.
  def frequency_in(parent_type = nil)
    unless parent_type
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
