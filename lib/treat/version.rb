module Treat
  
  # The current version of Treat.
  VERSION = '2.0.8'
  
  # Treat requires Ruby >= 1.9.2
  if RUBY_VERSION < '1.9.2'
    raise "Treat requires Ruby version 1.9.2 " +
    "or higher, but current is #{RUBY_VERSION}."
  end

end