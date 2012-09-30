module Treat
  
  # Load the basic Module functionality.
  require_relative 'module'
  
  # Contains configuration.
  module Config
    require_relative 'config'
  end

  # Contains utility functions used by Treat.
  module Helpers
    include Module::Autoloaded
  end

  # Contains classes to load external libraries.
  module Loaders
    include Module::Autoloadable
  end

  # Contains the core classes used by Treat.
  module Core
    include Module::Autoloaded
  end

  # Contains the textual model used by Treat.
  module Entities
    require_relative 'entities/entity'
    include Module::Autoloaded
  end

  # This module creates all the worker categories.
  module Workers
    require_relative 'workers'
  end

  # Proxies install builders on core Ruby objects.
  module Proxies
    require_relative 'proxies'
  end
  
end