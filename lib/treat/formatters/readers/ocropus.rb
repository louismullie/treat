module Treat
  module Formatters
    module Readers
      # This class is a wrapper for the Google Ocropus
      # optical character recognition (OCR) engine.
      # 
      # "OCRopus(tm) is a state-of-the-art document 
      # analysis and OCR system, featuring pluggable 
      # layout analysis, pluggable character recognition,
      # statistical natural language modeling, and multi-
      # lingual capabilities."
      # 
      # Original paper:
      # Breuel, Thomas M. The Ocropus Open Source OCR System. 
      # DFKI and U. Kaiserslautern, Germany.
      class Ocropus
        #  Read a file using the Google Ocropus reader.
        def self.read(document, options = {})
          create_temp_file(:txt) do |tmp|
            capture(:stderr) do
              `ocropus page #{document.file} > #{tmp} -STDIO 2>/dev/null`
            end
            f = File.read(tmp)
            document << Treat::Entities::Entity.from_string(f)
          end
          document
        end
      end
    end
  end
end
