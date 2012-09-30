module Treat
  
  module Autoloaded
    
    def self.included(base)
      bits =  base.to_s.split('::')
      name = bits[-1].downcase
      name = self.singularize(name) + '.rb'
      dir = File.join(Dir.pwd, 'lib/treat', 
      bits[1..-1].collect! { |ch| ch.
      downcase }.join('/')) + '/'
      require dir + name if 
      File.readable?(dir + name)
      patt = dir + '*.rb'
      Dir.glob(patt).each { |f| require f }
    end
    
    def self.singularize(name)
      (name[-3..-1] == 'ies' ? 
      (name[0...-3] + 'y') : (name[-1] == 
      's' ? name[0...-1] : name))
    end
    
  end
  
  # Contains configuration.
  module Config
    include Autoloaded
  end

  # Contains utility functions used by Treat.
  module Helpers
    include Autoloaded
  end

  # Contains classes to load external libraries.
  module Loaders
    include Autoloaded
  end

  # Contains the core classes used by Treat.
  module Learning
    include Autoloaded
  end

  # Contains the textual model used by Treat.
  module Entities
    include Autoloaded
  end

  # This module creates all the worker categories.
  module Workers
    include Autoloaded
  end

  # Proxies install builders on core Ruby objects.
  module Proxies
    include Autoloaded
  end
  
end