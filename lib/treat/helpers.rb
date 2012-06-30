# Contains utility functions used by Treat.
module Treat::Helpers
  p = Treat.paths.lib + 'treat/helpers/*.rb'
  Dir.glob(p).each { |f| require f }
end