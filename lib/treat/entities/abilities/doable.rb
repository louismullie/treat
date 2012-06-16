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
    self
  end

  # Perform an individual task on an entity
  # given a worker and options to pass to it.
  def do_task(task, worker, options, group = nil)
    group ||= get_group(task)
    entity_types = group.targets
    f = nil
    entity_types.each do |t|
      f = true if Treat::Entities.match_types[t][type]
    end
    if f || entity_types.include?(:entity)
      send(task, worker, options)
      if group.recursive
        each do |entity|
          entity.do_task(task, worker, options, group)
        end
      end
    else
      each do |entity|
        entity.do_task(task, worker, options, group)
      end
      unless entity_types.include?(type)
        features.delete(task)
      end
      nil
    end
  end

  # Get the group of a task.
  def get_group(task)
    g = Treat::Workers.lookup(task)
    unless g
      raise Treat::Exception,
      "Task #{task} does not exist."
    end
    g
  end


end
