module Treat
  # This module provides linguistic resources
  # for the Treat library, including information
  # about language codes, the functions available
  # for each language, and the different tags used
  # to markup that language.
  module Languages
    Dir["#{Treat.lib}/treat/languages/*.rb"].each { |file| require file }
    ISO639_1 = 1
    ISO639_2 = 2
    # Describe a language code (ISO-639-1 or ISO-639-2)
    # or its full text description in full French or English.
    def self.describe(lang, desc_lang = :en)
      raise "Must provide a non-nil language identifier to describe." if lang.nil?
      lang = code(lang).to_s
      if [:en, :eng, :english, :anglais].include?(desc_lang)
        l = @@english_full.key(lang)
      elsif [:fr, :fra, :french, :french].include?(desc_lang)
        l = @@french_full.key(lang)
      else
        raise Treat::Exception,
        "Unknown language to describe: #{desc_lang}."
      end
      not_found(lang) if l.nil?
      l.intern
    end
    # Raise an error message when a language code
    # or description is not found and suggest
    # possible misspellings.
    def self.not_found(lang)
      msg = "Language '#{lang}' does not exist."
      all = @@iso639_2.keys + @@iso639_1.keys +
      @@english_full.keys + @@french_full.keys
      msg += did_you_mean?(all, lang)
      raise Treat::Exception, msg
    end
    # Return the class representing a language.
    def self.get(lang)
      const_get(Treat::Languages.describe(lang).to_s.capitalize)
    end
    # Find a language by ISO-639-1 or ISO-639-2 code
    # or full name (in English or French) and return
    # the ISO-639-1 or ISO-639-2 language code as a
    # lowercase identifier.
    def self.code(lang, rc = ISO639_2)
      raise "Must provide a non-nil language identifier to describe." if lang.nil?
      get_languages
      lang = lang.to_s.downcase
      if @@iso639_1.has_key?(lang)
        return lang.intern if rc == ISO639_1
        return @@iso639_1[lang].intern if rc == ISO639_2
      elsif @@iso639_2.has_key?(lang)
        return lang.intern if rc == ISO639_2
        return @@iso639_2[lang].intern if rc == ISO639_1
      elsif @@english_full.has_key?(lang)
        return @@english_full[lang].intern if rc == ISO639_2
        return @@iso639_2[@@english_full[lang]].intern if rc == ISO639_1
      elsif @@french_full.has_key?(lang)
        return @@french_full[lang].intern if rc == ISO639_2
        return @@iso639_1[@@french_full[lang]].intern if rc == ISO639_2
      else
        not_found(lang)
      end
    end
    @@loaded = false
    # Get the languages from the dictionary.
    def self.get_languages
      return if @@loaded
      @@iso639_1 = {}; @@iso639_2 = {};
      @@english_full = {}; @@french_full = {}
      languages = IO.readlines(Treat.lib + '/treat/languages/list.txt')
      languages.each do |language|
        iso639_2, iso639_1, english_desc, french_desc =
        language.split(',')
        @@iso639_1[iso639_1] = iso639_2
        @@iso639_2[iso639_2] = iso639_1
        unless english_desc.nil?
          english_desc.strip.downcase.split('|').each do |l|
            @@english_full[l.downcase.strip] = iso639_2
          end
        end
        unless french_desc.nil?
          french_desc.strip.downcase.split('|').each do |l|
            @@french_full[l.downcase.strip] = iso639_2
          end
        end
      end
      @@loaded = true
    end
  end
end