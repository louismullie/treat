class Treat::Module
  
  module Autoloaded
    def self.included(base)
      Dir.glob(Dir.pwd + '/lib/treat/' + 
      base.to_s.split('::')[1..-1].
      collect! { |ch| ch.downcase }.
      join('/') + '/*.rb').
      each { |file| require file }
    end
  end
  
  module Autoloadable
    def self.const_missing(const)
      name = const.to_s.downcase
      mdir = base.to_s.
      split('::')[-1].downcase
      require Dir.pwd + '/lib/' + 
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