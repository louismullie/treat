class Treat::Module
  
  module Autoloaded
    def self.included(base)
      bits = base.ancestors[0].to_s.split('::').
      collect! { |bit| bit.downcase }
      Dir.glob(Treat.paths.lib +
      bits.join('/') + '/*.rb').
      each { |f| require_relative f }
    end
  end
  
  module Autoloadable
    def self.const_missing(const)
      name = const.to_s.downcase
      mdir = base.to_s.
      split('::')[-1].downcase
      require Treat.paths.lib + 
      "treat/#{mdir}/#{name}.rb"
      self.const_get(const)
    end
  end
  
  module Installable
    # Install packages for a given language.
    def self.install(language = :english)
      require_relative 'treat/installer'
      Treat::Installer.install(language)
    end
  end
  
end