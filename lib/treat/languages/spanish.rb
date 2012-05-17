class Treat::Languages::Spanish
  
  RequiredDependencies = []
  OptionalDependencies = []
  
  Extractors = {}
  Inflectors = {}
  Lexicalizers = {}
  Processors = {
    :chunkers => [:txt],
    :segmenters => [:tactful],
    :tokenizers => [:tactful]
  }
  Retrievers = {}
  
end
