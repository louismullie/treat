# Contains classes to load external libraries.
module Treat::Loaders
  # Autoload all of the loaders.
  def self.const_missing(const)
    name = const.to_s.downcase
    require Treat.paths.lib + 
    "treat/loaders/#{name}.rb"
    self.const_get(const)
  end
end