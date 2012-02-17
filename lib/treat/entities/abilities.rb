# Requires the -able mixins for the Entity class.
module Treat::Entities::Abilities
  
  p = 'treat/entities/abilities/*.rb'
  
  Dir[Treat.lib + p].each do |f| 
    require f
  end
  
end