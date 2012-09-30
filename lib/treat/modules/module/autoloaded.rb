module Treat::Modules::Module::Autoloaded

  def self.included(base)
    Dir.glob(Dir.pwd + '/lib/treat/' + 
    base.to_s.split('::')[1..-1].
    collect! { |ch| ch.downcase }.
    join('/') + '/*.rb').
    each { |file| require file }
  end
  
end