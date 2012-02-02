module Treat
  module Formatters
    module Readers
      class Doc
        def self.read(document, options = {})
          f = `antiword #{document.file}`
          f.gsub!("\n\n", '#keep#')
          f.gsub!("\n", ' ')
          f.gsub!('#keep#', "\n\n")
          document << Treat::Entities::Entity.from_string(f)
        end
      end
    end
  end
end