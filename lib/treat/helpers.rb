module Treat::Helpers
  # Require abilities.
   Dir.glob(Treat.paths.lib + 
    '/treat/helpers/*.rb').each do |f| 
     require f
   end
end