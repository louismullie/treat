# Registers the entities ocurring in the subtree of
# a node as children are added. Also registers text
# occurrences for word groups and tokens (n grams).
module Treat::Entities::Entity::Registrable

  # Registers a token or phrase in the registry.
  # The registry keeps track of children by id,
  # by entity type, and also keeps the position
  # of the entity in its parent entity.
  def register(entity)
    unless @registry 
      @count, @registry = 0, 
      {id: {}, value: {}, position:{}, type: {}} 
    end
    if entity.is_a?(Treat::Entities::Token) ||
      entity.is_a?(Treat::Entities::Group)
      val = entity.to_s.downcase
      @registry[:value][val] ||= 0
      @registry[:value][val] += 1
    end
    @registry[:id][entity.id] = true
    @registry[:type][entity.type] ||= 0
    @registry[:type][entity.type] += 1
    @registry[:position][entity.id] = @count
    @count += 1
    @parent.register(entity) if has_parent?
  end

  # Backtrack up the tree to find a token registry,
  # by default the one in the root node of the tree.
  def registry(type = nil)
    (has_parent? && type != self.type) ?
    @parent.registry(type) : @registry
  end

end
