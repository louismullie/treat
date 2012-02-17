class Treat::Languages::Greek
  
  RequiredDependencies = []
  OptionalDependencies = []
  
  Processors = {
    :chunkers => [:txt],
    :segmenters => [:punkt],
    :tokenizers => [:tactful]
  }
  Extractors = {}
  Inflectors = {}
  Lexicalizers = {}
  Retrievers = {}
  
end
