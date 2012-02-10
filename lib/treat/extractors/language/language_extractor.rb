# A generic language extractor, which is called before
# any language detector and ensures that configuration
# options concerning language are enforced (i.e returns
# the default language when Treat.detect_language is false).
class Treat::Extractors::Language::LanguageExtractor
  # Return the default language if Treat.detect_language
  # is set to false or the entity is a symbol or number
  # (which do not logically have a "language"). Returns
  # nil if Treat.detect_language is set to true and the
  # entity is not a symbol or number, in which case the
  # children class knows that it has to handle the call.
  def self.language(entity, options = {})
    if entity.is_a?(Treat::Entities::Symbol) ||
      entity.is_a?(Treat::Entities::Number)
      return Treat.default_language
    end
    if Treat.detect_language == false
      return Treat.default_language
    else
      dlvl = Treat.language_detection_level
      if (Entities.rank(entity.type) <
        Entities.rank(dlvl)) &&
        entity.has_parent?
        anc = entity.ancestor_with_type(dlvl)
        return anc.language if anc
      end
    end
  end
end
