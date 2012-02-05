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
        silence_warnings { require 'punkt-segmenter' }
        require 'psych'
        # Hold one copy of the segmenter per language.
        @@segmenters = {}
        # Hold only one trainer per language.
        @@trainers = {}
        # Segment a text using the Punkt segmenter gem.
        #
        # Options: 
        # 
        #   :training_text => (String) Text to train the segmenter on.
        def self.segment(entity, options = {})
          if options[:model]
            model = options[:model]
          else
            lang = entity.language
            l = Treat::Languages.describe(lang)
            model = "#{Treat.lib}/treat/processors/segmenters/punkt/#{l}.yaml"
            unless File.readable?(model)
              raise Treat::Exception,
              "Could not get the language model for the Punkt segmenter for #{l}."
            end
          end
          t = ::Psych.load(File.read(model))
          @@segmenters[lang] ||= ::Punkt::SentenceTokenizer.new(t)
          s = entity.to_s
          s.gsub!(/([^\.\?!]\.|\!|\?)([^\s])/) { $1 + ' ' + $2 }
          result = @@segmenters[lang].sentences_from_text(
            s, :output => :sentences_text)
          result.each do |sentence|
            entity << Treat::Entities::Phrase.from_string(sentence)
          end
        end
      end
    end
  end
end
