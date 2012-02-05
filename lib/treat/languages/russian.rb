module Treat
  module Languages
    class Russian
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