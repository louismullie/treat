# Contains the textual model used by Treat.
module Treat::Entities
  require_relative 'treat/entities/entity'
  p = Treat.paths.lib + 'treat/entities/*.rb'
  Dir.glob(p).each { |f| require f }
end