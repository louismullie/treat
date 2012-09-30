class Treat::Modules::Module
  # Require all of the module files
  Dir.glob(Dir.pwd + '/lib/treat/modules/' + 
  'module/*.rb').each { |f| require f }
end