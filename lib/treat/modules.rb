module Treat
  
  # Contains common utility/helper functions.
  module Helpers; include Autoload; end
  
  # Contains all the configuration options.
  module Config; include Autoload; end
  
  # Import all the configuration options.
  Treat::Config.import!

  # Contains classes to load external libraries.
  module Loaders; include Autoload; end

  # Contains machine learning core classes.
  module Learning; include Autoload; end

  # Contains the document object models.
  module Entities; include Autoload; end

  # Contains all the worker categories.
  module Workers; include Autoload; end
  
  # Make all the worker categories.
  Treat::Workers.categorize!
  
  # Installs builders on core Ruby objects.
  module Proxies; include Autoload; end
  
  # Core classes (installer, server, etc.)
  module Core; include Autoload; end
  
end