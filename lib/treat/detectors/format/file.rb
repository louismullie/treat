module Treat
  module Detectors
    module Format
      # A wrapper for the *NIX 'file' command,
      # witch uses etc/magic to detect the format
      # of a file.
      class File
        # Returns an identifier representing
        # the format of a file using the *NIX
        # 'file' command.
        # 
        # Options: none.
        def self.format(entity, options = {})
          format = nil
          create_temp_file(:txt, entity.to_s) do |tmp|
            format = `file #{tmp}` 
          end
          if format.scan('text')
            :txt
          elsif format.scan('XML')
            :xml
          elsif format.scan('HTML')
            :html
          elsif format.scan('image')
            :image
          elsif format.scan('PDF')
            :pdf
          else
            raise Treat::Exception,
            "Unsupported text format #{format}."
          end
        end
      end
    end
  end
end