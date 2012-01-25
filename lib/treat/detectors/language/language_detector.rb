module Treat
  module Detectors
    module Language
      # A generic language detector, which is called before
      # any language detector and ensures that configuration
      # options concerning language are enforced (e.g. returns
      # the default language when Treat.detect_language is false).
      class LanguageDetector
        def self.language(entity, options = {})
          if Treat.detect_language == false
            return Treat.default_language
          else
            dlvl = Treat.language_detection_level
            if (Entities.rank(entity.type) < Entities.rank(dlvl)) &&
               entity.has_parent?
               anc = entity.ancestor_with_type(dlvl)
               return anc.language if anc
            end
          end
        end
      end
    end
  end
end