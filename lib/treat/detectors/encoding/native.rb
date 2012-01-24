module Treat
  module Detectors
    module Encoding
      class Native
        def self.encoding(entity, options={})
          entity.value.encoding.name.
          gsub('-', '_').downcase.intern
        end
      end
    end
  end
end
