module Treat
  # Makes a class delegatable, allowing calls on it to be forwarded
  # to a delegate class performing the appropriate call.
  module Delegatable

    # Get the default delegate for that language
    # inside the given group.
    def get_language_delegate(language, group)
      lang = Treat::Resources::Languages.describe(language)
      lclass = cc(lang).intern
      if Treat::Resources::Delegates.constants.include?(lclass)
        cat = group.to_s.split('::')[-2].intern
        lclass = Treat::Resources::Delegates.
        const_get(lclass).const_get(cat)
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

    # Add decorator methods to entities.
    def decorate(group, m)
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

    # Raise an exception and suggest alternatives.
    def delegate_not_found(klass, group)
      "Algorithm '#{ucc(klass)}' couldn't be found in group #{group}." +
      did_you_mean?(group.list.map { |c| ucc(c) }, ucc(klass))
    end

    # Add delegator group to all entities of a class.
    def add_delegators(group)
      # Define each method in group.
      self.class_eval do
        m = group.method
        decorate(group, m)
        define_method(m) do |delegate=nil, options={}|
          decorator = options.delete(:decorator)
          puts self.id if !@features
          if !@features[m].nil?
            @features[m]
          else
            if delegate.nil?
              delegate = group.default.nil? ? 
              self.class.get_language_delegate(language, group) :
              group.default
              raise "No default delegate for #{group}." if delegate == :none
            end
            if not group.list.include?(delegate)
              raise Treat::Exception,
              self.class.delegate_not_found(delegate, group)
            else
              delegate_klass = group.const_get(:"#{cc(delegate.to_s)}")
              result = accept(group, delegate_klass, m, options)
              if decorator
                result = group.send(decorator, self, result)
              end
              if group.type == :annotator
                f = decorator.nil? ? m : decorator
                @features[f] = result
              end
              result
            end
          end
        end
      end
    end
  end
end
