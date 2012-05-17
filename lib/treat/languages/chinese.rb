class Treat::Languages::Chinese
  
  RequiredDependencies = []
  OptionalDependencies = []
  
  Extractors = {}
  Inflectors = {}
  Lexicalizers = {
    :taggers => [:stanford]
  }
  Processors = {
    :parsers => [:stanford]
  }
  Retrievers = {}
  
end
