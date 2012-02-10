# Custom exception class for the Treat toolkit.
# Used to distinguish between errors raised by
# gems/Ruby from errors raised by the toolkit.
module Treat
  class Exception < ::Exception; end
end