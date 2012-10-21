# This module uses structs to represent the 
# configuration options that are stored in 
# the /config folder.
module Treat::Config

  # Require configurable mix in.
  require_relative 'importable'
  
  # Make all configuration importable.
  extend Treat::Config::Importable
  
  # Core configuration options for entities.
  class Treat::Config::Entities; end
  
  # Configuration for paths to models, binaries,
  # temporary storage and file downloads.
  class Treat::Config::Paths; end
  
  # Configuration for all Treat workers.
  class Treat::Config::Workers; end

  # Helpful linguistic options.
  class Treat::Config::Linguistics; end

  # Supported workers for each language.
  class Treat::Config::Languages; end

  # Configuration options for external libraries.
  class Treat::Config::Libraries; end
  
  # Configuration options for database 
  # connectivity (host, port, etc.)
  class Treat::Config::Databases; end

  # Configuration options for Treat core.
  class Treat::Config::Core; end

end