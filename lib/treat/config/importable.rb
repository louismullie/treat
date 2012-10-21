# Mixin that is extended by Treat::Config
# in order to provide a single point of 
# access method to trigger the import.
module Treat::Config::Importable
  
  # Import relies on each configuration.
  require_relative 'configurable'
  
   # Store all the configuration in self.config
  def self.extended(base)
    class << base; attr_accessor :config; end
  end

  # Main function; loads all configuration options.
  def import!
    config, c = {}, Treat::Config::Configurable
    definition = :define_singleton_method
    Treat::Config.constants.each do |const|
      next if const.to_s.downcase.is_mixin?
      klass = Treat::Config.const_get(const)
      klass.class_eval { extend c }.configure!
      name = const.to_s.downcase.intern
      config[name] = klass.config
      Treat.send(definition, name) do
        Treat::Config.config[name]
      end
    end
    self.config = config.to_struct
  end
  
end