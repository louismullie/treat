module Treat
  module Languages
    class German
      Extractors = {}
      Inflectors = {}
      Lexicalizers = {
        tag: [:stanford]
      }
      Processors = {
        chunkers: [:txt],
        parsers: [:stanford],
        segmenters: [:punkt],
        tokenizers: [:tactful]
      }
    end
  end
end
