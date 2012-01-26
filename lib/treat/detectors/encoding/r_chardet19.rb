module Treat
  module Detectors
    module Encoding
      # Require the 'rchardet19' gem.
      silence_warnings { require 'rchardet19' }
      # A wrapper for the 'rchardet19' gem, which
      # detects the encoding of a file.
      class RChardet19
        # Returns the encoding of the document according
        # to the 'rchardet19' gem.
        #
        # Options: none.
        def self.encoding(document, options={})
          r = CharDet.detect(document.file)
          if r.encoding
            Treat::Feature.new({
              r.encoding.
              gsub('-', '_').downcase.intern =>
            r.confidence}).best
          else
            :unknown
          end
        end
      end
    end
  end
end
