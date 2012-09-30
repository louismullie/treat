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
    # Get the parts of module name.
    bits = base.to_s.split('::')
    # Singularize the module name.
    w = bits[-1].downcase
    n = (w[-3..-1] == 'ies' ? (w[0..-4] + 'y') :
    (w[-1] == 's' ? w[0...-1] : w)) + '.rb'
    # Get the module's directory.
    path = bits.join('/').downcase
    d = Dir.pwd + '/lib/' + path + '/'
    # Require base class if exists.
    require d + n if File.readable?(d + n)
    # Require all other files in dir.
    Dir.glob("#{d}*.rb").each { |f| require f }
  end
  
end