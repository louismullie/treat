module Treat::Groupable

  # Lazily load the worker classes in the group.
  def const_missing(const)
    bits = self.ancestors[0].to_s.split('::')
    bits.collect! { |bit| ucc(bit) }
    file = bits.join('/') + "/#{ucc(const)}"
    if not File.readable?("#{file}.rb")
      raise Treat::Exception,
      "File '#{file}.rb' corresponding to " +
      "requested worker #{self}::#{const} " +
      "does not exist."
    else
      require file
      if not const_defined?(const)
        raise Treat::Exception,
        "File #{file} does not define " +
        "#{self}::#{const}."
      end
      const_get(const)
    end
  end

  # Cache the list of workers to improve performance.
  @@list = {}
  # Populates once the list of the workers in the group
  # by crawling the filesystem.
  def list
    mod = ucc(cl(self))
    if @@list[mod].nil?
      @@list[mod] = []
      dirs = Dir.glob("treat/*/#{mod}/*.rb")
      dirs.each do |file|
        @@list[mod] <<
        file.split('/')[-1][0..-4].intern
      end
    end
    @@list[mod]
  end

  # Boolean - does the group have the supplied class
  # included in its targets?
  def has_target?(target, strict = false)
    is_target = false
    self.targets.each do |entity_type|
      t = cc(entity_type)
      entity_type = Treat::Entities.const_get(t)
      if target < entity_type ||
        entity_type == target
        is_target = true; break
      end
    end
    is_target
  end

  # Create a new algorithm within the group. Once
  # the algorithm is added, it will be automatically
  # installed on all the targets of the group.
  def add(class_name, &block)
    c = cc(class_name).intern
    klass = self.const_set(c, Class.new)
    method = self.method
    @@list[ucc(cl(self))] << class_name
    klass.send(:define_singleton_method,
    method) do |entity, options={}|
      block.call(entity, options)
    end
  end

  # Get constants in this module, excluding by
  # default those defined by parent modules.
  def const_get(const)
    super(const, false)
  end

  # Modify the extended class.
  def self.extended(group)
    
    group.module_eval do
      
      class << self
        
        # The type of the group. There are three types:
        #
        # - Transformers transform the tree of an entity.
        # - Annotators compute a value and store it in the entity.
        # - Computers compute a value and do not store it.
        attr_accessor :type
        # The default worker in the group, for language-
        # independent tasks.
        attr_accessor :default
        # The entity types which the group's workers work on.
        attr_accessor :targets
        # This will eventually be removed.
        attr_accessor :presets
      end
      
      # Initialize an empty hash of presets.
      self.presets = {}
      
      # Return the method corresponding to the group.
      # This method resolves the name of the method
      # that a group should provide based on the name
      # of the group. Basically, if the group ends in
      # -ers, the verb corresponding to the group is
      # returned (tokenizers -> tokenize, inflectors ->
      # inflect). Otherwise, the name of the method
      # is the same as that of the group (encoding ->
      # encoding, tag -> tag).
      @method = nil
      def self.method
        return @method if @method
        m = ucc(cl(self))
        if m[-3..-1] == 'ers'
          if ['k', 't', 'm', 'd', 'g', 'n', 'x', 'h'].include? m[-4]
            n = m[0..-4]
            n = n[0..-2] if n[-1] == n[-2]
          else
            n = m[0..-3]

          end
        elsif m[-3..-1] == 'ors'
          n = m[0..-4] + 'e'
        else
          n = m
        end
        @method = n.intern
      end
      group.list
    end
    
  end
  
end
