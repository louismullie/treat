module Treat
  # Makes a class delegatable, allowing calls on it to be forwarded
  # to a delegate class performing the appropriate call.
  module Delegatable
    # Add decorator methods to entities.
    def add_decorators(group, m)
      decorators = group.methods -
      Object.methods -
      [:type, :type=, :targets, :targets=,
        :default, :default=, :add,
      :has_target?, :list]
      decorators.each do |decorator_m|
        define_method(decorator_m) do |delegate=nil, options={}|
          options[:decorator] = decorator_m
          send(m, delegate, options)
        end
      end
    end
    # Add delegator group to all entities of a class.
    def add_delegators(group)
      # Define each method in group.
      self.class_eval do
        m = group.method
        add_decorators(group, m)
        define_method(m) do |delegate=nil, options={}|
          decorator = options.delete(:decorator)
          puts self.id if !@features
          if !@features[m].nil?
            @features[m]
          else
            self.class.call_delegator(
            self, m, delegate, decorator, 
            group, options)
          end
        end
      end
    end
    # Call a delegator.
    def call_delegator(entity, m, delegate, decorator, group, options)
      if delegate.nil?
        delegate = get_missing_delegate(entity, group)
      end
      if not group.list.include?(delegate)
        raise Treat::Exception, delegate_not_found(delegate, group)
      else
        delegate_klass = group.const_get(:"#{cc(delegate.to_s)}")
        result = entity.accept(group, delegate_klass, m, options)
        if decorator
          result = group.send(decorator, entity, result)
        end
        if group.type == :annotator
          f = decorator.nil? ? m : decorator
          entity.features[f] = result
        end
        result
      end
    end
    # Get the default delegate for that language
    # inside the given group.
    def get_language_delegate(language, group)
      lang = Treat::Languages.describe(language)
      lclass = cc(lang).intern
      if Treat::Languages.constants.include?(lclass)
        cat = group.to_s.split('::')[-2].intern
        lclass = Treat::Languages.const_get(lclass).const_get(cat)
        g = ucc(cl(group)).intern
        if !lclass[g] || !lclass[g][0]
          d = ucc(cl(group))
          d.gsub!('_', ' ')
          d = d[0..-2] if d[-1] == 's'
          d = 'delegator to find ' + d
          raise Treat::Exception, "No #{d}" +
          " is available for the #{lang} language."
        end
        return lclass[g][0]
      else
        raise Treat::Exception,
        "Language '#{lang}' is not supported (yet)."
      end
    end
    # Get which delegate to use if none has been supplied.
    def get_missing_delegate(entity, group)
      delegate = group.default.nil? ?
      self.get_language_delegate(entity.language, group) :
      group.default
      if delegate == :none
        raise NAT::Exception,
        "There is intentionally no default delegate for #{group}."
      end
      delegate
    end
    # Return an error message and suggest possible typos.
    def delegate_not_found(klass, group)
      "Algorithm '#{ucc(klass)}' couldn't be found in group #{group}." +
      did_you_mean?(group.list.map { |c| ucc(c) }, ucc(klass))
    end
  end
end
