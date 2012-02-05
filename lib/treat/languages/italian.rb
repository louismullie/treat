module Treat
  module Languages
    class Italian
      RequiredDependencies = []
      OptionalDependencies = []
      Extractors = {}
      Inflectors = {}
      Lexicalizers = {}
      Processors = {
        :chunkers => [:txt],
        :parsers => [:stanford],
        :segmenters => [:punkt],
        :tokenizers => [:tactful]
      }
    end
  end
end
