module Treat::Config

  Paths = [ :tmp, :lib, :bin, 
  :files, :data, :models, :spec ]

  class << self
    attr_accessor :config
  end

  Treat.module_eval do
    # Handle all missing methods as conf options.
    def self.method_missing(sym, *args, &block)
      super(sym, *args, &block) if sym == :to_ary
      Treat::Config.config[sym]
    end
  end

  def self.configure
    # Temporary configuration hash.
    config = { paths: {} }
    confdir = get_full_path(:lib) + 'treat/config'
    # Iterate over each directory in the config.
    Dir[confdir + '/*'].each do |dir|
      name = File.basename(dir, '.*').intern
      config[name] = {}
      # Iterate over each file in the directory.
      Dir[confdir + "/#{name}/*.rb"].each do |file|
        key = File.basename(file, '.*').intern
        config[name][key] = eval(File.read(file))
      end
    end
    # Get the path config.
    Paths.each do |path|
      config[:paths][path] = get_full_path(path)
    end
    # Get the tag alignments.
    configure_tags!(config[:tags][:aligned])
    # Convert hash to structs.
    self.config = self.hash_to_struct(config)
  end

  def self.get_full_path(dir)
    File.dirname(__FILE__) +
    '/../../' + dir.to_s + "/"
  end
  
  def self.configure_tags!(config)
    ts = config[:tag_sets]
    config[:word_tags_to_category] = 
    align_tags(config[:word_tags], ts)
    config[:phrase_tags_to_category] =
    align_tags(config[:phrase_tags], ts)
  end

  # Align tag configuration.
  def self.align_tags(tags, tag_sets)
    wttc = {}
    tags.each_slice(2) do |desc, tags|
      category = desc.gsub(',', ' ,').
      split(' ')[0].downcase
      tag_sets.each_with_index do |tag_set, i|
        next unless tags[i]
        wttc[tags[i]] ||= {}
        wttc[tags[i]][tag_set] = category
      end
    end
    wttc
  end
  
  def self.hash_to_struct(hash)
    return hash if hash.keys.
    select { |k| !k.is_a?(Symbol) }.size > 0
    struct = Struct.new(
    *hash.keys).new(*hash.values)
    hash.each do |key, value|
      if value.is_a?(Hash)
        struct[key] =
        self.hash_to_struct(value)
      end
    end
    struct
  end

  # Turn on syntactic sugar.
  def self.sweeten!
    
    # Undo this in unsweeten! - # Fix
    Treat::Entities.module_eval do 
      self.constants.each do |type|
        define_singleton_method(type) do |value='', id=nil|
          const_get(type).build(value, id)
        end
      end
    end
    
    return if Treat.core.syntax.sweetened
    Treat.core.syntax.sweetened = true
    Treat.core.entities.list.each do |type|
      kname = type.to_s.capitalize.intern
      klass = Treat::Entities.const_get(kname)
      Object.class_eval do
        define_method(kname.to_s.downcase.intern) do |val, opts={}|
          klass.build(val, opts)
        end
        # THIS WILL BE DEPRECATED IN 2.0
        define_method(kname) do |val, opts={}|
          klass.build(val, opts)
        end
      end
    end
    
    Treat::Core.constants.each do |kname|
      Object.class_eval do
        klass = Treat::Core.const_get(kname)
        define_method(kname.to_s.downcase.intern) do |*args|
          klass.new(*args)
        end
        # THIS WILL BE DEPRECATED IN 2.0
        define_method(kname) do |*args|
          klass.new(*args)
        end
      end
    end
    
  end

  # Turn off syntactic sugar.
  def self.unsweeten!
    return unless Treat.core.syntax.sweetened
    Treat.core.syntax.sweetened = false
    Treat.core.entities.list.each do |type|
      name = cc(type).intern
      Object.class_eval { remove_method(name) }
    end

  end

  # Run all configuration.
  self.configure

end
