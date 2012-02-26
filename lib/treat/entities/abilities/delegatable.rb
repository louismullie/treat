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

  @@prev = nil
  @@i = 0
  DEBUG = true

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
    if Treat::Languages.constants.include?(klass)
      cat = group.to_s.split('::')[-2].intern
      klass = Treat::Languages.get(klass).const_get(cat)

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

  # Explain what Treat is currently doing.
  def print_debug(entity, task, worker, group, options)

    targs = group.targets.map do |target| 
      target.to_s
    end
    if targs.size == 1
      t = targs[0]
    else
      t = targs[0..-2].join(', ') + 
      ' and ' + targs[-1]
    end
    
    genitive = targs.size > 1 ? 
    'their' : 'its'
    
    doing = ''

    if group.type == :transformer ||
      group.type == :computer
      tt = task.to_s.dup
      tt = tt[0..-2] if tt[-1] == 'e'
      ed = tt[-1] == 'd' ? '' : 'ed'
      doing = "#{tt.capitalize}#{ed} #{t}"
    elsif group.type == :annotator
      doing = "Annotated #{t} with " +
      "#{genitive} #{task.to_s}"
    end
    
    if group.to_s.index('Formatters')
      curr = doing + 
      ' in format ' + 
      worker.to_s
    else
      curr = doing + 
      ' using ' + 
      worker.to_s
    end
    
    if group.preset_option
      opt = options[group.preset_option]
      curr += " with #{group.preset_option} " +
      "set to #{opt}"
    end
    if curr == @@prev
      @@i += 1
    else
      if @@i > 1
        Treat::Entities.list.each do |e|
          @@prev.gsub!(e.to_s, e.to_s + 's')
        end
        @@prev.gsub!('its', 'their')
        @@prev = @@prev.split(' ').
        insert(1, @@i.to_s).join(' ')
      end
      @@i = 0
      puts @@prev
    end
    @@prev = curr

  end

end
