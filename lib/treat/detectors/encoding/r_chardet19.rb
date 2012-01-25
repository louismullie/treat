module Treat
  module Detectors
    module Encoding
      # Require the 'rchardet19' gem.
      silence_warnings { require 'rchardet19' }
      # A wrapper for the 'rchardet19' gem, which
      # detects the encoding of a file.
      class RChardet19
        # Returns the encoding of the entity according
        # to the 'rchardet19' gem.
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
