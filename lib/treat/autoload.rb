# Basic mixin for all the main modules;
# takes care of requiring the right files 
# in the right order for each one.
# 
# If a module's folder (e.g. /entities) 
# contains a file with a corresponding
# singular name (e.g. /entity), that 
# base class is required first. Then, 
# all the files that are found directly 
# under that folder are required (but
# not those found in sub-folders).
module Treat::Autoload
  
  # Loads all the files for the base
  # module in the appropriate order.
  def self.included(base)
    m = self.get_module_name(base)
    d = self.get_module_path(m)
    n = self.singularize(m) + '.rb'
    f, p = File.join(d, n), "#{d}/*.rb"
    require f if File.readable?(f)
    Dir.glob(p).each { |f| require f }
  end

  # Returns the path to a module's dir.
  def self.get_module_path(name)
    file = File.expand_path(__FILE__)
    dirs = File.dirname(file).split('/')
    File.join(*dirs[0..-1], name)
  end
  
  # Return the downcased form of the
  # module's last name (e.g. "entities").
  def self.get_module_name(mod)
    mod.to_s.split('::')[-1].downcase
  end
    
  # Helper method to singularize words.
  def self.singularize(w)
    if w[-3..-1] == 'ies'; w[0..-4] +  'y'
    else; (w[-1] == 's' ? w[0..-2] : w); end
  end
  
end