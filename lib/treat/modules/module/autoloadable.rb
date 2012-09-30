module Treat::Modules::Module::Autoloadable
  
  def self.const_missing(const)
    require "#{Dir.pwd}/lib/" +
    "treat/#{base.to_s}/" +
    const.to_s.downcase.
    split('::')[-1].downcase + '.rb'
    self.const_get(const)
  end
  
end