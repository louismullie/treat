module Treat
  module Formatters
    module Readers
      # This class isn't a wrapper for anything.
      # It simply delegates the reading task to
      # the appropriate reader based on the file
      # extension of the supplied document.
      class Autoselect
        # A list of image extensions that should be routed
        # to the Ocropus OCR engine.
        ImageExtensions = ['gif', 'jpg', 'jpeg', 'png']
        # Select the appropriate reader based on the format
        # of the filename in document.
        # 
        # Options:
        # :ocr => :ocropus | :gocr (the OCR engine to use).
        def self.read(document, options = {:ocr => :ocropus})
          ext = document.file.split('.')[-1]
          if ImageExtensions.include?(ext)
            reader = 'ocropus'
          else
            reader = ext
          end
          begin
            r = Treat::Formatters::Readers.const_get(cc(reader))
          rescue NameError
            raise Treat::Exception,
            "Cannot find a default reader for format: '#{ext}'."
          end
          document = r.read(document, options)
        end
      end
    end
  end
end
