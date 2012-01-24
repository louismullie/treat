module Treat
  module Formatters
    module Readers
      class PDF
        require 'fileutils'
        # Read a file using the Poppler pdf2text utility.
        def self.read(document, options = {})
          create_temp_file(:txt) do |tmp|
            `pdftotext #{document.file} #{tmp} `.strip
            document << Treat::Entities::Entity.from_string(File.read(tmp))
          end
          document
        end
      end
    end
  end
end
