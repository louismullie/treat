module Treat
  module Formatters
    module Readers
      class Doc
        def self.read(document, options = {})
          f = `antiword #{document.file}`
          document << Treat::Entities::Entity.from_string(f)
          document
        end
      end
    end
  end
end