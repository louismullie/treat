# Registers occurences of textual values inside
# all children entity. Useful to calculate frequency.
module Treat::Entities::Entity::Registrable

  # Registers a token in the @registry hash.
  def register(entity)
    
    unless @registry
      @count = 0
      @registry = {
        :value => {}, 
        :position => {}, 
        :type => {}, 
        :id => {}
      }
    end
    
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

end
