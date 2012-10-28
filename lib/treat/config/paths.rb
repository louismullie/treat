# Generates the following path config options:
# Treat.paths.tmp, Treat.paths.bin, Treat.paths.lib,
# Treat.paths.models, Treat.paths.files, Treat.paths.spec.
class Treat::Config::Paths
  
  # Get the path configuration based on the 
  # directory structure loaded into Paths.
  # Note that this doesn't call super, as
  # there is no external config files to load.
  def self.configure!
    root = File.dirname(File.expand_path(         # FIXME
    __FILE__)).split('/')[0..-4].join('/') + '/'
    self.config = Hash[
    # Get a list of directories in treat/
    Dir.glob(root + '*').select do |path|
      FileTest.directory?(path)
    # Map to pairs of [:name, path]
    end.map do |path|
      [File.basename(path).intern, path + '/']
    end]
  end
  
end
