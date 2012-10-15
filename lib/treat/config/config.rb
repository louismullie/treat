# This module uses structs to represent the 
# configuration options that are stored in 
# the /config folder.
module Treat::Config

  # Store all the configuration in self.config
  class << self; attr_accessor :config; end

  # Setup a proxy on the main Treat module to 
  # make configuration options directly accessible,
  # using e.g. Treat.paths.tmp = '...'
  Treat.module_eval do
    # Handle all missing methods as conf options.
    # Instead, should dynamically define them. FIXME.
    def self.method_missing(sym, *args, &block)
      super(sym, *args, &block) if sym == :to_ary
      Treat::Config.config[sym]
    end
  end
  
  # Main function; loads all configuration options.
  def self.configure!
    Treat::Config.constants.each do |const|
      unless [:Config, :Autoloadable].include?(const)
        config[const.to_s.downcase.intern] = 
        Treat::Config.const_get(const)
      end
    end
    self.config = self.hash_to_struct(config)
  end

  # Turn on syntactic sugar. This means that
  # all entities and learning classes can be 
  # created in a "Python-like" syntax in the 
  # global namespace (e.g. Word('hello'), 
  # Phrase('a bird'), etc.).
  def self.sweeten!
    return if Treat.core.syntax.sweetened
    Treat.core.syntax.sweetened = true
    Treat::Entities.sweeten_entities
    Treat::Entities.sweeten_learning
  end

  # Turn off syntactic sugar. See #sweeten!
  def self.unsweeten!
    self.sweeten_entities(false)
    self.sweeten_learning(false)
  end

  # Get the path to the config directory.
  def self.get_path
    File.dirname(File.expand_path(
    __FILE__)).split('/')[0..-4].join('/') + '/'
  end
  
  # Convert a hash to nested structs.
  def self.hash_to_struct(hash)
    return hash if hash.keys.
    select { |k| !k.is_a?(Symbol) }.size > 0
    struct = Struct.new(*hash.keys).new(*hash.values)
    hash.each do |key, value|
      if value.is_a?(Hash)
        struct[key] = self.hash_to_struct(value)
      end
    end; return struct
  end
  
end