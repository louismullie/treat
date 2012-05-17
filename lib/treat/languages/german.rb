class Treat::Languages::German
  
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
