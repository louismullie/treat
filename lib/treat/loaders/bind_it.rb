class Treat::Loaders::BindIt
  
  # Keep track of whether its loaded or not.
  @@loaded = {}
  
  # Load CoreNLP package for a given language.
  def self.load(klass, name, language = nil)
    
    return if @@loaded[klass]
    
    language ||= Treat.core.language.default

    jar_path   = Treat.libraries[name].jar_path || 
                 Treat.paths.bin + "#{name}/"
    model_path = Treat.libraries[name].model_path || 
                 Treat.paths.models + "#{name}/"
               
    if !File.directory?(jar_path)
      raise Treat::Exception, "Looking for #{klass} " +
      "library JAR files in #{jar_path}, but it is " +
      "not a directory. Please set the config option " +
      "Treat.libraries.#{name}.jar_path to a folder " +
      "containing the appropriate JAR files."
    end
    
    if !File.directory?(model_path)
      raise Treat::Exception, "Looking for #{klass} " +
      "library model files in #{model_path}, but it " +
      "is not a directory. Please set the config option " +
      "Treat.libraries.#{name}.model_path to a folder " +
      "containing the appropriate JAR files."
    end
    
    klass.jar_path = jar_path
    klass.model_path = model_path
    klass.use language
    
    if Treat.core.verbosity.silence
      klass.log_file = '/dev/null' 
    end

    klass.bind
    
    @@loaded[klass] = true
    
  end

end
