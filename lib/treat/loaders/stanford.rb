# A helper class to load the CoreNLP package.
class Treat::Loaders::Stanford
  
  # Keep track of whether its loaded or not.
  @@loaded = false
  
  # Load CoreNLP package for a given language.
  def self.load(language = nil)
    
    return if @@loaded
    
    language ||= Treat.core.language.default

    jar_path   = Treat.libraries.stanford.jar_path || 
                 Treat.paths.bin + 'stanford/'
    model_path = Treat.libraries.stanford.model_path || 
                 Treat.paths.models + 'stanford/'
               
    if !File.directory?(jar_path)
      raise Treat::Exception, "Looking for Stanford " +
      "CoreNLP JAR files in #{jar_path}, but it is " +
      "not a directory. Please set the config option " +
      "Treat.libraries.stanford.jar_path to a folder " +
      "containing the Stanford JAR files."
    end
    
    if !File.directory?(model_path)
      raise Treat::Exception, "Looking for Stanford " +
      "CoreNLP model files in #{model_path}, but it " +
      "is not a directory. Please set the config option " +
      "Treat.libraries.stanford.model_path to a folder " +
      "containing the Stanford JAR files."
    end
    
    require 'stanford-core-nlp'
    
    StanfordCoreNLP.jar_path = jar_path
    StanfordCoreNLP.model_path = model_path
    StanfordCoreNLP.use(language)
    
    if Treat.core.verbosity.silence
      StanfordCoreNLP.log_file = '/dev/null' 
    end

    @@loaded = true
    
  end
  
  def self.find_model(name, language)
    language = language.intern
    model_file = StanfordCoreNLP::Config::Models[name][language]
    model_dir  = StanfordCoreNLP::Config::ModelFolders[name]
    model_path = Treat.libraries.stanford.model_path ||
    File.join(Treat.paths.models, 'stanford')
    File.join(model_path, model_dir, model_file)
  end

end
