module Treat::Universalisation
  
  p = 'treat/universalisation/*.rb'
  
  Dir[Treat.lib + p].each do |f| 
    require f
  end
  
end