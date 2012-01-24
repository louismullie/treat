module Treat
  module Lexicalizers
    module Tag
      class Stanford
        # Require the Ruby-Java bridge.
        silently do
          require 'rjb'
          jar = "#{Treat.bin}/stanford_tagger/stanford-postagger.jar"
          unless File.readable?(jar)
            raise "Could not find stanford tagger JAR file in #{jar}."+
            " You may need to set Treat.bin to a custom value."
          end
          Rjb::load(
            "#{Treat.bin}/stanford_tagger/stanford-postagger.jar", 
            ['-Xms256M', '-Xmx512M']
          )
          MaxentTagger = ::Rjb::import('edu.stanford.nlp.tagger.maxent.MaxentTagger')
          Word = ::Rjb::import('edu.stanford.nlp.ling.Word')
          List = ::Rjb::import('java.util.ArrayList')
        end
        # A list of models to use by language.
        # Other models are available; see the models/ folder
        # in the Stanford Tagger distribution files.
        LanguageToModel = {
          eng: 'english-left3words-distsim.tagger',
          ger: 'german-fast.tagger',
          fra: 'french.tagger',
          ara: 'arabic-fast.tagger',
          chi: 'chinese.tagger'
        }
        # Hold one tagger per language.
        @@taggers = {}
        # Hold the user-set options for each language.
        @@options = {}
        # Hold the default options.
        DefaultOptions =  {}
        # Tag the word using one of the Stanford taggers.
        def self.tag(entity, options = {})
          lang = entity.language
          # Find the model.
          if options[:model]
            model = options[:model]
          else
            model = LanguageToModel[lang]
            if model.nil?
              raise Treat::Exception "There exists no Stanford" +
              "tagger model for language #{lang}."
            end
          end
          # Reinitialize the tagger if the options have changed.
          if options != @@options[lang]
            @@options[lang] = DefaultOptions.merge(options)
            @@taggers[lang] = nil # Reset the tagger
          end
          if @@taggers[lang].nil?
            model = "#{Treat.bin}/stanford_tagger/models/#{model}"
            unless File.readable?(model)
              raise "Could not find a tagger model for language #{lang}: looking in #{model}."
            end
            silence_streams(STDOUT, STDERR) do
              @@taggers[lang] =
              MaxentTagger.new(model)
            end
          end
          list = List.new
          id_list = {}
          i = 0
          [entity].each do |word|    # Fix...
            list.add(Word.new(word.to_s))
            id_list[i] = word
            i += 1
          end
          it = nil
          it = @@taggers[lang].apply(list).iterator
          i = 0
          while it.has_next
            w = it.next
            id_list[i].set :tag, w.tag
            i += 1
          end
          w.tag
        end
      end
    end
  end
end
