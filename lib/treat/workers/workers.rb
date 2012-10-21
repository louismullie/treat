module Treat::Workers
  # Require mixins for workers.
  require_relative 'categorizable'
  # Make all workers categorizable.
  extend Treat::Workers::Categorizable
end