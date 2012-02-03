module Treat
  # Detectors detect a specific meta-information about
  # an entity, such as encoding, format and language.
  # 
  # Detectors are language-independent, and thus there
  # are default algorithms specified for each of them.
  module Detectors
    # Group for algorithms that detect encoding.
    module Encoding 
      extend Group
      self.type = :annotator
      self.targets = [:document]
      self.default = :r_chardet19
    end
    # Group for algorithms that support format detection.
    module Format
      extend Group
      self.type = :annotator
      self.targets = [:document]
      self.default = :file
    end

    extend Treat::Category
  end
end