# Registers occurences of textual values inside
# all children entity. Useful to calculate frequency.
module Treat::Entities::Abilities::Registrable

  # Registers a token in the @registry hash.
  def register(entity)
    
    if entity.is_a?(Treat::Entities::Token) ||
      entity.is_a?(Treat::Entities::Phrase)
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
  # by default the one in the root node of any entity.
  def registry(type = nil)
    if has_parent? &&
      type != self.type
      @parent.registry(type)
    else
      @registry
    end
  end

  def contains_id?(id)
    
    @registry[:id][id]
    
  end

  def contains_value?(val)
    
    @registry[:value][val] ?
    true : false
    
  end

  def contains_type?(type1)
    
    return true if @registry[:type][type1]
    
    @registry[:type].each do |type2, count|
      if Treat::Entities.
        match_types[type1][type2]
        return true
      end
    end
    
    false
    
  end

  def contains_types?(types)
    
    types.each do |type|
      return true if contains_type?(type)
    end
    
    false
    
  end

end
