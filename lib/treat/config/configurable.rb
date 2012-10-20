module Treat::Config::Configurable

  def self.extended(base)
    class << base; attr_accessor :config; end
    base.class_eval { self.config = {} }
  end
  
  def configure!
    path = File.dirname(File.expand_path(         # FIXME
    __FILE__)).split('/')[0..-4].join('/') + '/'
    main_dir = path + 'lib/treat/config/data/'
    mod_name = self.name.split('::')[-1].downcase
    conf_dir = main_dir + mod_name
    base_file = main_dir + mod_name + '.rb'
    if File.readable?(base_file)
      self.config = eval(File.read(base_file))
    end
    if FileTest.directory?(conf_dir)
      config = {}
      Dir[conf_dir + '/*'].each do |path|
        name = File.basename(path, '.*').intern
        config[name] = eval(File.read(path))
      end
      self.config = config
    end
  end
  
end
