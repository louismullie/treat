module Treat
  module Doable
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
    def do_task(task, worker, options)
      group = Categories.lookup(task)
      entity_types = group.targets
      if entity_types.include?(type) ||
        entity_types.include?(:entity)
        send(task, worker, options)
      else
        i = 0
        each_entity(*entity_types) do |entity|
          i += 1
          entity.send(task, worker, options)
        end
        unless entity_types.include?(type)
          features.delete(task)
        end
        nil
      end
    end
  end
end
