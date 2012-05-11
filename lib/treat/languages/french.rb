class Treat::Languages::French
  
  RequiredDependencies = []
  OptionalDependencies = []
  
  Extractors = {}
  Inflectors = {}
  Lexicalizers = {
    :tag => [:stanford],
    :category => [:from_tag]
  }
  Processors = {
    :chunkers => [:txt],
    :parsers => [:stanford],
    :segmenters => [:punkt],
    :tokenizers => [:tactful]
  }
  Retrievers = {}
  
end
