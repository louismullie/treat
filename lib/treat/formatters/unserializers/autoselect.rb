module Treat
  module Formatters
    module Unserializers
      class Autoselect
        def self.unserialize(document, options = {})
          ext = document.file.split('.')[-1]
          if ext == 'yaml' || ext == 'yml'
            document.unserialize(:yaml)
          elsif ext == 'xml'
            document.unserialize(:xml)
          else
            raise "File #{document.file} was not recognized"+
            "as a supported serialized format."
          end
        end
      end
    end
  end
end
