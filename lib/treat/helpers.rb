# The Helpers namespace contains utility
# functions used across the library.
module Treat::Helpers
  p = Treat.paths.lib + 'treat/helpers/*.rb'
  Dir.glob(p).each { |f| require f }
end