# Makes a class delegatable, allowing calls
# on it to be forwarded to a worker class
# able to perform the appropriate task.
module Treat::Entities::Abilities::Delegatable

  # Add preset methods to an entity class.
  def add_presets(group)
    group.presets.each do |method, presets|
      define_method(method) do |worker=nil, options={}|
        options = presets.merge(options)
        m = group.method
        send(m, worker, options)
        features[method] = unset(m)
      end
    end
  end

  # Add the workers to perform a task on an entity class.
  def add_workers(group)
    self.class_eval do
      m = group.method
      add_presets(group)
      define_method(m) do |worker=nil, options={}|
        postprocessor =
        options.delete(:postprocessor)
        if !@features[m].nil?
          @features[m]
        else
          self.class.call_worker(
            self, m, worker,
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
      
      if group.type == :annotator
        entity.features[task] = result if result
      elsif group.type == :adnotator
        entity.features[task].merge(result)
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
    if Treat::Languages.constants.include?(klass)
      cat = group.to_s.split('::')[-2].intern
      klass = Treat::Languages.get(klass).const_get(cat)
      g = ucc(cl(group)).intern
      if !klass[g] || !klass[g][0]
        d = ucc(cl(group))
        d.gsub!('_', ' ')
        d = 'worker to find "' + d
        raise Treat::Exception, "No #{d}" +
        "\" is available for the #{lang} language."
      end
      return klass[g][0]
    else
      raise Treat::Exception,
      "Language '#{lang}' is not supported (yet)."
    end
  end

  # Return an error message and suggest possible typos.
  def worker_not_found(klass, group)
    "Algorithm '#{ucc(cl(klass))}' couldn't be "+
    "found in group #{group}." + did_you_mean?(
    group.list.map { |c| ucc(c) }, ucc(klass))
  end

end
