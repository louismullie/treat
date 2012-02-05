module Treat
  module Languages
    class French
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
    end
  end
end
