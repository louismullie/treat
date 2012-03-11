module Treat::Linguistics
  
  p = 'treat/linguistics/*.rb'
  
  Dir[Treat.lib + p].each do |f| 
    require f
  end
  
end