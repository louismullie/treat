module Treat
  # Make a tree visitable by implementing the method #accept.
  module Visitable
    # Accept a visitor implemented by klass, which is
    # found in the supplied group, and call method on it.
    def accept(group, klass, method, options)
      if group.has_target?(self.class)
        if group.type == :transformer
          if has_children?
            @children.each do |entity|
              if group.has_target?(entity.class) && entity.id != id
                entity.accept(group, klass, method, options)
              end
            end
          else
            klass.send(method, self, options)
          end
          return self
        else
          return klass.send(method, self, options)
        end
      else
        raise NAT::Exception,
        "This type of visitor cannot visit a #{self.class}."
      end
    end
  end
end
