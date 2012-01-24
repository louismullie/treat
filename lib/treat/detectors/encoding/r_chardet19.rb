module Treat
  module Detectors
    module Encoding
      # Require the 'rchardet19' gem.
      silently { require 'rchardet19' }
      # A wrapper for the 'rchardet19' gem, which
      # detects the encoding of a file.
      class RChardet19
        # Returns an Encoding object representing
        # the encoding of the supplied entity's 
        # text value.
        #
        # Options: none.
        def self.encoding(entity, options={})
          r = CharDet.detect(entity.to_s)
          Treat::Feature.new({
            r.encoding.
            gsub('-', '_').intern => 
            r.confidence}).best
        end
      end
    end
  end
end
