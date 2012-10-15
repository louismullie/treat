# Methods related to object reflection.
class Treat::Helpers::Object
  
  # Allow introspection onto what method called
  # another one at runtime (useful for debugging).
  module CallerMethod
    
    # Return the name of the method that 
    # called the method that calls this method.
    def caller_method(n = 3)
      at = caller(n).first
      /^(.+?):(\d+)(?::in `(.*)')?/ =~ at
      Regexp.last_match[3].
      gsub('block in ', '').intern
    end
    
  end

  # Retrieve the last name of a class/module
  # (i.e. the part after the last "::").
  module ModuleName
    
    def module_name; self.to_s.split('::')[-1]; end
    alias :mn :module_name
    
  end
  
  module Verbosity
    # Runs a block of code without warnings.
    def silence_warnings(&block)
      warn_level = $VERBOSE
      $VERBOSE = nil
      result = block.call
      $VERBOSE = warn_level
      result
    end

    # Runs a block of code while blocking stdout.
    def silence_stdout(log = '/dev/null')
      unless Treat.core.verbosity.silence
        yield; return
      end
      old = $stdout.dup
      $stdout.reopen(File.new(log, 'w'))
      yield
      $stdout = old
    end
  end
  
  # Allow getting the caller method in any context.
  Object.class_eval do
    include Treat::Helpers::Object::CallerMethod
  end
  
  # Allow getting the last name of any module/class.
  Module.class_eval do
    include Treat::Helpers::Object::ModuleName
  end
  
end