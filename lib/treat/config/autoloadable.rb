module Treat::Config::Readable

  def self.included(base)
    conf_dir = Trat::Config.get_path + 'lib/treat/config'
    conf_dir += '/' + base.mn.downcase
    config = {}
    # Iterate over each directory in the config.
    Dir[conf_dir + '/*'].each do |dir|
      name = File.basename(dir, '.*').intern
      next if name == :config; config[name] = {}
      # Iterate over each file in the directory.
      Dir[conf_dir + "/#{name}/*.rb"].each do |file|
        key = File.basename(file, '.*').intern
        config[name][key] = eval(File.read(file))
      end
    end
  end
  
end
