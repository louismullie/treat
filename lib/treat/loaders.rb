# Helper classes to load external libraries.
module Treat::Loaders
  
  p = 'treat/loaders/*.rb'
  
  Dir[Treat.lib + p].each do |f| 
    require f
  end
  
end