module Treat
  module Annotatable
    # Registers a token in the @token_registry
    # hash in the root node.
    def annotate(annotators)
      annotators.each do |annotation, delegate|
        delegate, options = *delegate if delegate.is_a?(Array)
        options ||= {}
        entity_types = Categories.lookup(annotation).targets
        if entity_types.include?(type)
          send(annotation, delegate)
        end
        self.each_entity(*entity_types) do |entity|
          entity.send(annotation, delegate, options)
        end
        unless entity_types.include?(type)
          features.delete(annotation)
        end
      end
    end
  end
end