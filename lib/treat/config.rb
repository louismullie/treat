module Treat::Config

  # Require configatron.
  require 'configatron'

  Paths = [
    :tmp, :lib, :bin, :files, 
    :data, :models, :spec
  ]

  Treat.module_eval do
    
    # Handle all missing methods as conf options.
    def self.method_missing(sym, *args, &block)
      configatron.send(sym, args, block)
    end

  end
  
  def self.configure
    self.configure_paths
    self.load_configuration
  end
  
  def self.configure_paths
    Paths.each do |path|
      s = "configatron.paths.#{path} = '" +
      File.dirname(__FILE__) + 
      '/../../' + path.to_s + "/'"
      eval s
    end
  end

  def self.load_configuration
    # Temporary configuration hash.
    config = {}
    path = Treat.paths.lib + 'treat/config'
    # Iterate over each directory in the config.
    Dir[path + '/*'].each do |dir|
      name = File.basename(dir, '.*').intern
      # Iterate over each file in the directory.
      Dir[path + "/#{name}/*.rb"].each do |file|
        key = File.basename(file, '.*').intern
        eval "configatron.#{name}.#{key}" +
        " = #{File.read(file)}"
      end
    end
    configatron.configure_from_hash(config)

  end
  
  # Turn on syntactic sugar.
  def self.sweeten!
    return if Treat.core.syntax[:sweetened?]
    Treat.core.syntax[:sweetened?] = true
    Treat.core.entities.each do |type|
      next if type == :Symbol
      kname = type.to_s.capitalize.intern
      klass = Treat::Entities.const_get(kname)
      Object.class_eval do
        define_method(kname) do |value, options={}|
          klass.build(value, options)
        end
      end
    end
  end

  # Turn off syntactic sugar.
  def self.unsweeten!
    return unless Treat.core.syntax[:sweetened?]
    Treat.core.syntax[:sweetened?] = false

    Treat.core.entities.each do |type|
      kname = type.to_s.capitalize.intern
      Object.class_eval do
        # undef kname
      end unless type == :symbol
    end

  end
  
  # Run all configuration.
  self.configure
  
end
