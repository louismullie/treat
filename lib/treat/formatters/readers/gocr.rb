module Treat
  module Formatters
    module Readers
      # A wrapper class for the GOCR engine.
      # 
      # "GOCR is an OCR (Optical Character Recognition) 
      # program, developed under the GNU Public License. 
      # It converts scanned images of text back to text files."
      # 
      # Project site: http://jocr.sourceforge.net
      class GOCR
        # Read a file using the GOCR reader.
        #
        # Options: none.
        def self.read(document, options = {})
          create_temp_file(:pgm) do |tmp|
            `convert #{document.file} #{tmp}`
            f = `gocr #{tmp}`.strip
            document << Treat::Entities::Entity.from_string(f)
          end
          document
        end
      end
    end
  end
end
