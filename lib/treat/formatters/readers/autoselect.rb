module Treat
  module Formatters
    module Readers
      # This class isn't a wrapper for anything.
      # It simply delegates the reading task to
      # the appropriate reader based on the file
      # extension of the supplied document.
      class Autoselect
        # A list of image extensions that should be routed to OCR.
        ImageExtensions = ['gif', 'jpg', 'jpeg', 'png']
        # Default options.
        DefaultOptions = {:ocr => :ocropus}
        # Select the appropriate reader based on the format
        # of the filename in document.
        # 
        # Options:
        #
        # - :ocr_engine => :ocropus or :gocr (the OCR engine to use).
        def self.read(document, options)
          options = DefaultOptions.merge(options)
          ext = document.file.split('.')[-1]
          reader = ImageExtensions.include?(ext) ? 'ocropus' : ext
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
