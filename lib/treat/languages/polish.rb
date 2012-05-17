class Treat::Languages::Polish
  
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
