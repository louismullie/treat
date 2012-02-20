# Enable entities to be visited by workers.
module Treat::Entities::Abilities::Visitable
  
  # Accept a worker performing the specified
  # task with the supplied options.
  def accept(task, worker, group, options)

    if group.has_target?(self.class)
      if group.type == :transformer
        if has_children?
          @children.each do |entity|
            if entity.id != id && 
              group.has_target?(entity.class)
                entity.accept(
                task, worker, 
                group, options)
            end
          end
        else
          worker.send(task, self, options)
        end
        self
      else
        worker.send(task, self, options)
      end
    else
      raise Treat::Exception,
      "This type of visitor cannot "+
      "visit a #{self.class}."
    end
    
  end
  
end