# Provide default functionality to load configuration
# options from flat files into their respective modules.
module Treat::Config::Configurable
  
  # When extended, add the .config property to
  # the class that is being operated on.
  def self.extended(base)
    class << base; attr_accessor :config; end
    base.class_eval { self.config = {} }
  end
  
  # Provide base functionality to configure 
  # all modules. The behaviour is as follows:
  # 
  # 1 - Check if a file named data/$CLASS$.rb
  # exists; if so, load that file as the base 
  # configuration, i.e. "Treat.$CLASS$"; e.g. 
  # "Treat.core"
  # 
  # 2 - Check if a folder named data/$CLASS$
  # exists; if so, load each file in that folder
  # as a suboption of the main configuration,
  # i.e. "Treat.$CLASS$.$FILE$"; e.g. "Treat.workers"
  # 
  # (where $CLASS$ is the lowercase name of 
  # the concrete class being extended by this.)
  def configure!
    path = File.dirname(File.expand_path(         # FIXME
    __FILE__)).split('/')[0..-4].join('/') + '/'
    main_dir = path + 'lib/treat/config/data/'
    mod_name = self.name.split('::')[-1].downcase
    conf_dir = main_dir + mod_name
    base_file = main_dir + mod_name + '.rb'
    if File.readable?(base_file)
      self.config = eval(File.read(base_file))
    elsif FileTest.directory?(conf_dir)
      self.config = self.from_dir(conf_dir)
    else; raise Treat::Exception,
      "No config file found for #{mod_name}."
    end
  end
  
  # * Helper methods for configuraton * #
  def from_dir(conf_dir)
    Hash[Dir[conf_dir + '/*'].map do |path|
      name = File.basename(path, '.*').intern
      [name, eval(File.read(path))]
    end]
  end
  
end
