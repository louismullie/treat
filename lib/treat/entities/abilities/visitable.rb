# Enable entities to be visited by workers.
module Treat::Entities::Abilities::Visitable
  
  # Accept a worker performing the specified
  # task with the supplied options.
  def accept(task, worker, group, options)

    if group.has_target?(self.class)
      r = worker.send(task, self, options)
      return self if group.type == :transformer
      return r
    else
      raise Treat::Exception,
      "This type of visitor cannot "+
      "visit a #{self.class}."
    end
    
  end
  
end
