module Treat::Core
  Dir[Treat.paths.lib + 'treat/core/*.rb'].each do |f|
    require f
  end
end