module Treat::Proxies
  
  # This is kind of ugly; need to find a
  # better solution eventually (?)
  Treat::Entities::Entity.class_eval do
    
    # Rename the true language detection
    # method to :language_proxied, and
    # only call it if language detection
    # is turned on in the configuration.
    alias :language_proxied :language
    
    # Proxy the #language method, defined on
    # all textual entities, in order to catch
    # the method call if language detection is
    # turned off and return the default language
    # in that case.
    def language(extractor = nil, options = {})
  
      return Treat.core.language.default if
      !Treat.core.language.detect

      if is_a?(Treat::Entities::Symbol) ||
        is_a?(Treat::Entities::Number) ||
        is_a?(Treat::Entities::Punctuation)
        return Treat.core.language.default
      end

      dlvl = Treat.core.language.detect_at
      dklass = Treat::Entities.const_get(dlvl.cc)
      
      if self.class.compare_with(dklass) < 1
        anc = ancestor_with_type(dlvl)
        return anc.language if anc
        return self.parent.language if has_parent?
      end

      extractor ||= Treat.workers.
      extractors.language.default

      language_proxied(extractor, options)

    end

  end

end
