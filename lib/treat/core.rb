module Treat::Core
  p = Treat.paths.lib + 'treat/core/*.rb'
  Dir.glob(p).each { |f| require f }
end