class Treat::Languages::Portuguese
  
  RequiredDependencies = []
  OptionalDependencies = []

  Extractors = {}
  Inflectors = {}
  Lexicalizers = {}
  Processors = {
    :chunkers => [:txt],
    :segmenters => [:punkt],
    :tokenizers => [:tactful]
  }
  Retrievers = {}
  
end
