class Treat::Languages::Dutch
  
  RequiredDependencies = []
  OptionalDependencies = []
  
  Processors = {
    :chunkers => [:txt],
    :segmenters => [:punkt],
    :tokenizers => [:perl, :tactful]
  }
  Extractors = {}
  Inflectors = {}
  Lexicalizers = {}
  Retrievers = {}
  
end
