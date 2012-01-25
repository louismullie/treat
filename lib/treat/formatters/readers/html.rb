module Treat
  module Formatters
    module Readers
      # A temporary HTML reader; simply strips the
      # document of all of its markup.
      class HTML
        # Read the HTML document and strip it of its markup.
        def self.read(document, options = {})
          f = File.read(document.file)
          document << Treat::Entities::Entity.from_string(f)
          document.clean(:html)
        end
      end
    end
  end
end
