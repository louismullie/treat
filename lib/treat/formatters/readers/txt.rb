module Treat
  module Formatters
    module Readers
      # This class simply reads a plain text file.
      class Txt
        # Build an entity from a string in plain text format.
        def self.read(document, options = {})
          f = File.read(document.file)
          document << Treat::Entities::Entity.from_string(f)
          document
        end
      end
    end
  end
end