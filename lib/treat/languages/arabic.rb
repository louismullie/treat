class Treat::Languages::Arabic
  
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
