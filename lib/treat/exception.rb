module Treat
  # Custom exception class for the Treat toolkit.
  # Used to distinguish between errors raised by
  # gems/Ruby from errors raised by the toolkit.
  class Exception < ::Exception; end
  class InvalidInputException < Exception; end
end