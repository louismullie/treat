module Treat
  # Custom exception class for the Treat toolkit.
  # Used to distinguish between errors raised by
  # gems or Ruby from errors raised by the toolkit.
  class Exception < ::Exception
  end
end
