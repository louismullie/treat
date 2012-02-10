# Registers occurences of textual values inside
# all children entity. Useful to calculate frequency.
module Treat::Entities::Abilities::Registrable
  
  # Registers a token in the @token_registry hash.
  def register_token(token)
    @token_registry ||= {:value => {}, :id => {}}
    @token_registry[:id][token.id] = token
    v = token.to_s.downcase
    @token_registry[:value][v] ||= []
    @token_registry[:value][v] << token
    @parent.register_token(token) if has_parent?
  end
  
  # Backtrack up the tree to find a token registry,
  # by default the one in the root node of any entity.
  def token_registry(type = nil)
    if (type == nil && is_root?) || type == self.type
      @token_registry ||=
      {:value => {}, :id => {}}
      return @token_registry
    else
      if has_parent?
        @parent.token_registry(type)
      else
        @token_registry ||=
        {:value => {}, :id => {}}
        @token_registry
      end
    end
  end
  
end
