# Contains classes to load external libraries.
module Treat::Loaders
  p = Treat.paths.lib + 'treat/loaders/*.rb'
  Dir.glob(p).each { |f| require f }
end