module Treat
  module Languages
    class Xinhua
      Extractors = {}
      Inflectors = {}
      Lexicalizers = {}
      Processors = {
        parsers: [:stanford]
      }
    end
  end
end
