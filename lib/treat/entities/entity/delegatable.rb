# Makes a class delegatable, allowing calls
# on it to be forwarded to a worker class
# able to perform the appropriate task.
module Treat::Entities::Entity::Delegatable

  # Add preset methods to an entity class.
  def add_presets(group)

    opt = group.preset_option
    return unless opt

    self.class_eval do
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
    group, options) if Treat.core.verbosity.debug
    if not group.list.include?(worker)
      raise Treat::Exception,
      worker_not_found(worker, group)
    end

    worker = group.const_get(worker.to_s.cc.intern)
    result = worker.send(group.method, entity, options)

    if group.type == :annotator && result
      entity.features[task] = result
    end

    if group.type == :transformer
      entity
    else
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
    lang = Treat.languages[language]
    cat = group.to_s.split('::')[2].downcase.intern
    group = group.mn.ucc.intern
    if lang.nil?
      raise Treat::Exception,
      "No configuration file loaded for language #{language}."
    end
    workers = lang.workers
    if !workers.respond_to?(cat) ||
       !workers[cat].respond_to?(group)
        workers = Treat.languages.agnostic.workers
    end
    if !workers.respond_to?(cat) || 
       !workers[cat].respond_to?(group)
      raise Treat::Exception,
      "No #{group} is/are available for the " +
      "#{language.to_s.capitalize} language."
    end
    workers[cat][group].first
  end

  # Return an error message and suggest possible typos.
  def worker_not_found(worker, group)
    "Worker with name '#{worker}' couldn't be "+
    "found in group #{group}." + Treat::Helpers::Help.
    did_you_mean?(group.list.map { |c| c.ucc }, worker)
  end

end
