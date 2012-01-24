module Treat
  module Detectors
    module Language
      # Require the 'whatlanguage' gem.
      silently { require 'whatlanguage'  }
      # Adaptor for the 'whatlanguage' gem, which
      # performs probabilistic language detection.
      class WhatLanguage < LanguageDetector
        # Keep only once instance of the gem class.
        @@wl = nil
        # Detect the language of an entity using the
        # 'whatlanguage' gem. Return an identifier
        # corresponding to the ISO-639-2 code for the
        # language.
        def self.language(entity, options = {})
          predetection = super(entity, options)
          return predetection if predetection
          @@wl ||= ::WhatLanguage.new(:all)
          all = @@wl.process_text(entity.to_s)
          lang = {}
          all.each do |k,v|
            lang[Treat::Resources::Languages.find(k)] = v
          end
          Treat::Feature.new(lang).best
        end
      end
    end
  end
end
