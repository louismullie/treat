module Treat::Entities::Abilities::Countable

  # Find the position of the current entity
  # inside the parent entity.
  def position_in_parent(parent_type = nil)
    return unless has_parent?
    p = parent_type ? 
    ancestor_with_type(parent_type) : parent
    p.children.index(self)
  end
  
  alias :position :position_in_parent
  
  # Find the frequency of the entity in
  # the supplied parent.
  def frequency_in_parent(parent_type = nil)
    tr = token_registry(parent_type)
    tv = tr[:value][value]
    tv ? tv.size : 1
  end
  
  # Returns the frequency of the given value
  # in the parent_entity.
  def frequency_of(value)
    return 0 unless has_children?
    tv = @token_registry[:value][value]
    tv ? tv.size : 1
  end
  
  alias :frequency :frequency_in_parent
  alias :frequency_in :frequency_in_parent
  
end