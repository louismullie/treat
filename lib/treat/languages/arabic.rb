module Treat
  module Languages
    class Arabic
      Extractors = {}
      Inflectors = {}
      Lexicalizers = {
        tag: [:stanford]
      }
      Processors = {
        parsers: [:stanford]
      }
    end
  end
end
