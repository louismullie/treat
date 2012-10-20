class Treat::Config::Paths
  
  # Get the path configuration based on the 
  # directory structure loaded into Paths.
  def self.configure!
    super
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
