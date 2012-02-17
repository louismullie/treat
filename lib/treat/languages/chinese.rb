class Treat::Languages::Chinese
  
  RequiredDependencies = []
  OptionalDependencies = []
  
  Extractors = {}
  Inflectors = {}
  Lexicalizers = {
    :tag => [:stanford]
  }
  Processors = {
    :parsers => [:stanford]
  }
  Retrievers = {}
  
end
