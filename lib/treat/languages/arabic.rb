module Treat
  module Languages
    class Arabic
      RequiredDependencies = []
      OptionalDependencies = []
      Extractors = {}
      Inflectors = {}
      Lexicalizers = {
        :tag => [:stanford]
      }
      Processors = {
        :parsers => [:stanford]
      }
    end
  end
end
