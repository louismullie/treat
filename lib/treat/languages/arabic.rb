class Treat::Languages::Arabic
  
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
