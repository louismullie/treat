class Treat::Languages::Italian
  
  RequiredDependencies = []
  OptionalDependencies = []
  
  Processors = {
    :chunkers => [:txt],
    :parsers => [:stanford],
    :segmenters => [:punkt],
    :tokenizers => [:perl, :tactful]
  }
  Extractors = {}
  Inflectors = {}
  Lexicalizers = {}
  Retrievers = {}
  
end
