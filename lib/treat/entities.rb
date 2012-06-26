module Treat::Entities

  # Require the base tree node class.
  require 'treat/entities/node'
  # Require the base entity class.
  require 'treat/entities/entity'
  require 'treat/entities/list'
  
  # Maps Treat::Entities::X() to 
  # Treat::Entities::X.build().
  self.constants.each do |type|
    define_singleton_method(type) do |value='', id=nil|
      const_get(type).build(value, id)
    end
  end

end
