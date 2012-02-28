# Makes a class delegatable, allowing calls
# on it to be forwarded to a worker class
# able to perform the appropriate task.
module Treat::Entities::Abilities::Delegatable

  # Add preset methods to an entity class.
  def add_presets(group)

    opt = group.preset_option
    return unless opt

    group.presets.each do |preset|
      define_method(preset) do |worker=nil, options={}|
        return get(preset) if has?(preset)
        options = {opt => preset}.merge(options)
        m = group.method
        send(m, worker, options)
        f = unset(m)
        features[preset] = f if f
      end
    end

  end

  # Add the workers to perform a task on an entity class.
  def add_workers(group)

    self.class_eval do
      task = group.method
      add_presets(group)
      define_method(task) do |worker=nil, options={}|
        if worker.is_a?(Hash)
          options, worker =
          worker, nil
        end
        if !@features[task].nil?
          @features[task]
        else
          self.class.call_worker(
          self, task, worker,
          group, options
          )
        end
      end
    end

  end

  # Ask a worker found in the given group to perform
  # a task on the entity with the supplied options.
  def call_worker(entity, task, worker, group, options)

    if worker.nil? || worker == :default
      worker = find_worker(entity, group)
    end

    print_debug(entity, task, worker,
    group, options) if Treat.debug
    
    if not group.list.include?(worker)
      raise Treat::Exception,
      worker_not_found(worker, group)
    else

      worker = group.const_get(
      cc(worker.to_s).intern
      )

      result = entity.accept(
      task, worker, group, options
      )

      if group.type == :annotator && result
        entity.features[task] = result
      end

      result

    end
  end

  # Find which worker to use if none has been supplied.
  def find_worker(entity, group)
    group.default.nil? ?
    self.find_worker_for_language(
    entity.language, group) :
    group.default
  end

  # Get the default worker for that language
  # inside the given group.
  def find_worker_for_language(language, group)
    
    lang = Treat::Languages.describe(language)
    klass = cc(lang).intern
    lclass = Treat::Languages.const_get(klass)
    cat = group.to_s.split('::')[-2].intern
    klass = lclass.const_get(cat)
    
    g = ucc(cl(group)).intern
    
    if !klass[g] || !klass[g][0]
      d = ucc(cl(group))
      d.gsub!('_', ' ')
      d = 'worker to find "' + d
      raise Treat::Exception, "No #{d}" +
      "\" is available for the " +
      "#{lang.to_s.capitalize} language."
    end
    return klass[g][0]

  end

  # Return an error message and suggest possible typos.
  def worker_not_found(klass, group)
    "Algorithm '#{ucc(cl(klass))}' couldn't be "+
    "found in group #{group}." + did_you_mean?(
    group.list.map { |c| ucc(c) }, ucc(klass))
  end

end
