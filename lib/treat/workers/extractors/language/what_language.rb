# Language detection using a probabilistic algorithm
# that checks for the presence of words with Bloom
# filters built from dictionaries for each language.
#
# Original paper: Grothoff. 2007. A Quick Introduction to
# Bloom Filters. Department of Computer Sciences, Purdue
# University.
class Treat::Workers::Extractors::Language::WhatLanguage

  # Require the 'whatlanguage' gem.
  silence_warnings { require 'whatlanguage'  }

  # Undefine the method defined by the gem.
  String.class_eval { undef :language }

  # By default, bias towards common languages.
  DefaultOptions = {
    :bias_toward => [:english, :french, :chinese, :german, :arabic, :spanish]
  }

  # Keep only once instance of the gem class.
  @@detector = nil

  # Detect the language of an entity using the
  # 'whatlanguage' gem. Return an identifier
  # corresponding to the ISO-639-2 code for the
  # language.
  #
  # Options:
  #
  # - (Array of Symbols) bias => Languages to bias
  # toward when more than one language is detected
  # with equal probability.
  def self.language(entity, options = {})

    options = DefaultOptions.merge(options)

    @@detector ||= ::WhatLanguage.new(:all)
    possibilities = @@detector.process_text(entity.to_s)
    lang = {}

    possibilities.each do |k,v|
      lang[k.intern] = v
    end

    max = lang.values.max
    ordered = lang.select { |i,j| j == max }.keys

    ordered.each do |l|
      if options[:bias_toward].include?(l)
        return l
      end
    end

    return ordered.first

  end

end
