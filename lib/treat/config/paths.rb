module Treat::Config::Paths
  
  # * Helper methods for path config * #
  
  # Get the path configuration based on the 
  # directory structure loaded into Paths.
  def self.get_paths_config
    Hash[
    # Get a list of directories in treat/
    Dir.glob(self.get_path + '*').select do |path|
      FileTest.directory?(path)
    # Map to pairs of [:name, path]
    end.map do |path|
      [File.basename(path).intern, path + '/']
    end]
  end
  
  config[:paths] = self.get_paths_config
  
end
