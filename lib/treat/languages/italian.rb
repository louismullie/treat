module Treat
  module Languages
    class Italian
      Extractors = {}
      Inflectors = {}
      Lexicalizers = {}
      Processors = {
        chunkers: [:txt],
        parsers: [:stanford],
        segmenters: [:punkt],
        tokenizers: [:tactful]
      }
    end
  end
end
