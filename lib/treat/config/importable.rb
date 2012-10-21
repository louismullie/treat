module Treat::Config::Importable
  
  # Import relies on each configuration.
  require_relative 'configurable'
  
   # Store all the configuration in self.config
  def self.extended(base)
    class << base; attr_accessor :config; end
  end

  # Main function; loads all configuration options.
  def import!
    config = {}
    Treat::Config.constants.each do |const|
      next if const.to_s.downcase.is_mixin?
      klass = Treat::Config.const_get(const)
      klass.class_eval do
        extend Treat::Config::Configurable
      end
      k = const.to_s.downcase.intern
      klass.configure!
      config[k] = klass.config
      d = :define_singleton_method
      Treat.send(d, k) do
        Treat::Config.config[k]
      end
    end
    self.config = config.to_struct
  end
  
end