module Treat
  module Formatters
    module Readers
      class HTML
        def self.read(document, options = {})
          f = File.read(document.file)
          document << Treat::Entities::Entity.from_string(f)
          document.clean(:html)
        end
      end
    end
  end
end
