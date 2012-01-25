module Treat
  module Detectors
    module Encoding
      # A wrapper class for Ruby's native encoding detector.
      class Native
        # Return the encoding of the entity according
        # to the Ruby interpreter.
        #
        # Options: none.
        def self.encoding(entity, options={})
          entity.value.encoding.name.
          gsub('-', '_').downcase.intern
        end
      end
    end
  end
end
