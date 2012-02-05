module Treat
  module Languages
    class Portuguese
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
    end
  end
end
