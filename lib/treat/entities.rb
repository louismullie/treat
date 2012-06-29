module Treat::Entities
  require 'treat/entities/entity'
  p = Treat.paths.lib + 'treat/entities/*.rb'
  Dir.glob(p).each { |f| require f }
end