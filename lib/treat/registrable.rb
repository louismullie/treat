module Treat
  module Registrable
    # Registers a token in the @token_registry
    # hash in the root node.
    def register_token(token)
      if is_root? || type == :document
        @token_registry ||= {value: {}, id: {}}
        @token_registry[:id][token.id] = token
        @token_registry[:value][token.to_s] ||= []
        @token_registry[:value][token.to_s] << token
        if has_parent? && type == :document
          @parent.register_token(token)
        end
      else
        @parent.register_token(token)
      end
    end
    # Find the token registry, which is 
    # always in the root node.
    def token_registry(type = nil)
      if self.type == type
        @token_registry ||= {value: {}, id: {}}
        return @token_registry
      end
      if has_parent?
        @parent.token_registry(type)
      else
        @token_registry ||= {value: {}, id: {}}
        @token_registry
      end
    end
  end
end
