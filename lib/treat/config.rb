module Treat::Config

  Paths = [
    :tmp, :lib, :bin, :files,
    :data, :models, :spec
  ]

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
    config = {paths: {}}
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
    # Convert hash to structs.
    self.config = self.hash_to_struct(config)
  end


  def self.get_full_path(dir)
    File.dirname(__FILE__) +
    '/../../' + dir.to_s + "/"
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
    return if Treat.core.syntax.sweetened
    Treat.core.syntax.sweetened = true
    Treat.core.entities.each do |type|
      next if type == :Symbol
      kname = cc(type).intern
      klass = Treat::Entities.const_get(kname)
      Object.class_eval do
        define_method(kname) do |val, opts={}|
          klass.build(val, opts)
        end
      end
    end
  end

  # Turn off syntactic sugar.
  def self.unsweeten!
    return unless Treat.core.syntax.sweetened
    Treat.core.syntax.sweetened = false
    Treat.core.entities.each do |type|
      name = cc(type).intern
      next if type == :Symbol
      Object.class_eval { remove_method(name) }
    end

  end

  # Run all configuration.
  self.configure

end
