module Treat
  # Makes a class delegatable, allowing calls on it to be forwarded
  # to a worker class performing the appropriate call.
  module Delegatable
    # Add postprocessor methods to entities.
    def add_presets(group)
      group.presets.each do |preset_m, presets|
        define_method(preset_m) do |worker=nil, options={}|
          options = presets.merge(options)
          m = group.method
          send(m, worker, options)
          features[preset_m] = unset(m)
        end
      end
    end
    def add_preprocessors(group)
      group.preprocessors.each do |preprocessor_m, block|
        define_method(preprocessor_m) do |worker=nil, options={}|
          block.call(self, worker, options)
          features[preprocessor_m] = unset(group.method)
        end
      end
    end
    # Add postprocessor methods to entities.
    def add_postprocessors(group, m)
      group.postprocessors.each do |postprocessor_m, block|
        define_method(postprocessor_m) do |worker=nil, options={}|
          options[:postprocessor] = postprocessor_m
          send(m, worker, options)
        end
      end
    end
    # Add worker group to all entities of a class.
    def add_workers(group)
      # Define each method in group.
      self.class_eval do
        m = group.method
        add_presets(group)
        add_preprocessors(group)
        add_postprocessors(group, m)
        define_method(m) do |worker=nil, options={}|
          postprocessor = 
            options.delete(:postprocessor)
          if !@features[m].nil?
            @features[m]
          else
            self.class.call_worker(
              self, m, worker, 
              postprocessor, 
              group, options
            )
          end
        end
      end
    end
    # Call a worker.
    def call_worker(entity, m, worker, postprocessor, group, options)
      if worker.nil? || worker == :default
        worker = find_worker(entity, group)
      end
      if not group.list.include?(worker)
        raise Treat::Exception, worker_not_found(worker, group)
      else
        worker_klass = group.const_get(cc(worker.to_s).intern)
        result = entity.accept(group, worker_klass, m, options)
        if postprocessor
          result = group.postprocessors[postprocessor].call(entity, result)
        end
        if group.type == :annotator
          f = postprocessor.nil? ? m : postprocessor
          entity.features[f] = result
        end
        result
      end
    end
    # Get the default worker for that language
    # inside the given group.
    def find_worker_for_language(language, group)
      lang = Treat::Languages.describe(language)
      lclass = cc(lang).intern
      if Treat::Languages.constants.include?(lclass)
        cat = group.to_s.split('::')[-2].intern
        lclass = Treat::Languages.get(lclass).const_get(cat)
        g = ucc(cl(group)).intern
        if !lclass[g] || !lclass[g][0]
          d = ucc(cl(group))
          d.gsub!('_', ' ')
          d = 'worker to find "' + d
          raise Treat::Exception, "No #{d}" +
          "\" is available for the #{lang} language."
        end
        return lclass[g][0]
      else
        raise Treat::Exception,
        "Language '#{lang}' is not supported (yet)."
      end
    end
    # Get which worker to use if none has been supplied.
    def find_worker(entity, group)
      worker = group.default.nil? ?
      self.find_worker_for_language(entity.language, group) :
      group.default
      if worker == :none
        raise NAT::Exception,
        "There is intentionally no default worker for #{group}."
      end
      worker
    end
    # Return an error message and suggest possible typos.
    def worker_not_found(klass, group)
      "Algorithm '#{ucc(cl(klass))}' couldn't be found in group #{group}." +
      did_you_mean?(group.list.map { |c| ucc(c) }, ucc(klass))
    end
  end
end
