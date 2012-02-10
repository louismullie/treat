# Implement support for the functions #do and #do_task.
module Treat::Entities::Abilities::Doable

  # Perform the supplied tasks on the entity.
  def do(*tasks)
    tasks.each do |task|
      if task.is_a?(Hash)
        task.each do |k,v|
          t, w = k, v
          w, o = *w if w.is_a?(Array)
          o ||= {}
          do_task(t, w, o)
        end
      else
        t = task.is_a?(Array) ? task[0] : task
        w = task.is_a?(Array) ? task[1] : nil
        w, o = *w if w.is_a?(Array)
        o ||= {}
        do_task(t, w, o)
      end
    end
  end

  # Perform an individual task on an entity
  # given a worker and options to pass to it.
  def do_task(task, worker, options)
    group = Treat::Categories.lookup(task)
    unless group
      raise Treat::Exception,
      "Task #{task} does not exist."
    end
    entity_types = group.targets
    f = nil
    entity_types.each do |t|
      f = true if Treat::Entities.match_types[t][type]
    end
    if f || entity_types.include?(:entity)
      send(task, worker, options)
    else
      each_entity(*entity_types) do |entity|
        entity.do_task(task, worker, options)
      end
      unless entity_types.include?(type)
        features.delete(task)
      end
      nil
    end

  end
end
