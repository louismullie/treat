module Treat
  module Formatters
    module Readers
      # This class isn't a wrapper for anything.
      # It simply delegates the reading task to
      # the appropriate reader based on the file
      # extension of the supplied document.
      class Autoselect
        # A list of image extensions that should be routed to Ocropus.
        ImageExtensions = ['gif', 'jpg', 'jpeg', 'png']
        # Select the appropriate reader based on the format
        # of the filename in document.
        # 
        # Options:
        #
        # - :ocr_engine => :ocropus or :gocr (the OCR engine to use).
        def self.read(document, options)
          ext = document.file.split('.')[-1]
          reader = ImageExtensions.include?(ext) ? 'image' : ext
          reader = 'html' if reader == 'htm'
          reader = 'yaml' if reader == 'yml'
          begin
            r = Treat::Formatters::Readers.const_get(cc(reader))
          rescue NameError
            puts e.message
            raise Treat::Exception,
            "Cannot find a reader for format: '#{ext}'."
          end
          document = r.read(document, options)
        end
      end
    end
  end
end
