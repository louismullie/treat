module Treat
  module Processors
    module Segmenters
      # An adapter for the 'punk-segmenter' gem, which segments
      # texts into sentences based on an unsupervised, language
      # independent algorithm.
      # 
      # Original paper: Kiss, Tibor and Strunk, Jan (2006): 
      # Unsupervised Multilingual Sentence Boundary Detection. 
      # Computational Linguistics 32: 485-525.
      class Punkt
        silently { require 'punkt-segmenter' }
        # Hold one copy of the segmenter per language.
        @@segmenters = {}
        # Hold only one trainer per language.
        @@trainers = {}
        # Texts to train the segmenter on.
        @@training_texts = {
          eng:  "A minute is a unit of measurement of time or of angle. The minute is a unit of time equal to 1/60th of an hour or 60 seconds by 1. In the UTC time scale, a minute occasionally has 59 or 61 seconds; see leap second. The minute is not an SI unit; however, it is accepted for use with SI units. The symbol for minute or minutes is min. The fact that an hour contains 60 minutes is probably due to influences from the Babylonians, who used a base-60 or sexagesimal counting system. Colloquially, a min. may also refer to an indefinite amount of time substantially longer than the standardized length."
        }
        # Segment a text using the Punkt segmenter gem.
        #
        # Options: 
        #   :training_text => (String) Text to train the segmenter on.
        def self.segment(entity, options = {})
          lang = entity.language
          training_text = options[:training_text] ? 
          options[:training_text] : @@training_texts[lang]
          unless training_text
            raise "No training text available for language #{lang}."
          end
          if @@trainers[lang].nil?
            @@trainers[lang] = ::Punkt::Trainer.new
            @@trainers[lang].train(training_text)
            @@segmenters[lang] = 
            ::Punkt::SentenceTokenizer.new(@@trainers[lang].parameters)
          end
          result = @@segmenters[lang].sentences_from_text(entity.to_s, 
            :output => :sentences_text)
          result.each do |sentence|
            entity << Entities::Entity.from_string(sentence)
          end
          entity
        end
      end
    end
  end
end
