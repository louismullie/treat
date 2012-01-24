module Treat
  module Registrable
    # Registers a token in the @token_registry
    # hash in the root node.
    def register_token(token)
      if is_root?
        @token_registry ||= {value: {}, id: {}}
        @token_registry[:id][token.id] = token
        @token_registry[:value][token.value] ||= []
        @token_registry[:value][token.value] << token
      else
        @parent.register_token(token)
      end
    end
    # Find the token registry, which is 
    # always in the root node.
    def token_registry
      if has_parent?
        @parent.token_registry
      else
        @token_registry ||= {value: {}, id: {}}
        @token_registry
      end
    end
  end
end
