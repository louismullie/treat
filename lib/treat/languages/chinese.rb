module Treat
  module Languages
    class Chinese
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
