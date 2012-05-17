class Treat::Languages::French
  
  RequiredDependencies = []
  OptionalDependencies = []
  
  Extractors = {}
  Inflectors = {}
  Lexicalizers = {
    :taggers => [:stanford],
    :categorizers => [:from_tag]
  }
  Processors = {
    :chunkers => [:txt],
    :parsers => [:stanford],
    :segmenters => [:tactful],
    :tokenizers => [:tactful]
  }
  Retrievers = {}
  
end
