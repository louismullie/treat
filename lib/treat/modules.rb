module Treat
  
  module Modules
    require_relative 'modules/module'
  end
  
  # Contains configuration.
  module Config
    require_relative 'modules/config'
  end

  # Contains utility functions used by Treat.
  module Helpers
    include Modules::Module::Autoloaded
  end

  # Contains classes to load external libraries.
  module Loaders
    include Modules::Module::Autoloadable
  end

  # Contains the core classes used by Treat.
  module Learning
    include Modules::Module::Autoloaded
  end

  # Contains the textual model used by Treat.
  module Entities
    require_relative 'entities/entity'
    include Modules::Module::Autoloaded
  end

  # This module creates all the worker categories.
  module Workers
    require_relative 'modules/workers'
  end

  # Proxies install builders on core Ruby objects.
  module Proxies
    require_relative 'modules/proxies'
  end
  
end