module Treat
  module Languages
    class Italian
      Extractors = {}
      Inflectors = {}
      Lexicalizers = {}
      Processors = {
        chunkers: [:txt],
        segmenters: [:tactful, :punkt, :stanford],
        tokenizers: [:multilingual, :macintyre, :perl, :punkt, :tactful, :stanford]
      }
    end
  end
end
