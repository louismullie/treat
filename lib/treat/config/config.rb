# This module uses structs to represent the 
# configuration options that are stored in 
# the /config folder.
module Treat::Config

  class Treat::Config::Entities; end
  
  class Treat::Config::Paths; end
  
  class Treat::Config::Workers; end

  class Treat::Config::Linguistics; end

  class Treat::Config::Languages; end

  class Treat::Config::Libraries; end

  class Treat::Config::Workers; end
  
  class Treat::Config::Databases; end

  class Treat::Config::Core; end
  
  # Require autolodable mix in.
  require_relative 'configurable'
  
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
    config = {}
    Treat::Config.constants.each do |const|
      unless const == :Configurable
        klass = Treat::Config.const_get(const)
        klass.class_eval do
          extend Treat::Config::Configurable
        end
        k = const.to_s.downcase.intern
        klass.configure!
        config[k] = klass.config
      end
    end
    self.config = self.hash_to_struct(config)
  end

  # * Helper methods * #
  
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