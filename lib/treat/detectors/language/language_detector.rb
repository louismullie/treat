module Treat
  module Detectors
    module Language
      class LanguageDetector
        def self.language(entity, options = {})
          if Treat.detect_language == false
            return Treat.default_language
          else
            dlvl = Treat.language_detection_level
            if (Entities.rank(entity.type) < Entities.rank(dlvl)) &&
               entity.has_parent?
                return entity.ancestor_with_type(dlvl).language
            end
          end
        end
      end
    end
  end
end