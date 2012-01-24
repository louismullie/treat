module Treat
  module Lexicalizers
    module Tag
      class Stanford
        # Require the Ruby-Java bridge.
        silently do
          require 'rjb'
          jar = "#{Treat.bin}/stanford-tagger*/stanford-postagger*.jar"
          jars = Dir.glob(jar)
          if jars.empty? || !File.readable?(jars[0])
            raise "Could not find stanford tagger JAR file (looking in #{jar})."+
            " You may need to manually download the JAR files and/or set Treat.bin."
          end
          Rjb::load(jars[0], ['-Xms256M', '-Xmx512M'])
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
              raise Treat::Exception, "There exists no Stanford tagger model for " +
              "the #{Treat::Resources::Languages.describe(lang)} language ."
            end
          end
          # Reinitialize the tagger if the options have changed.
          if options != @@options[lang]
            @@options[lang] = DefaultOptions.merge(options)
            @@taggers[lang] = nil # Reset the tagger
          end
          if @@taggers[lang].nil?
            model = "#{Treat.bin}/stanford-tagger*/models/#{model}"
            models = Dir.glob(model)
            if models.empty? || !File.readable?(models[0])
              raise "Could not find a tagger model for the " +
              "#{Treat::Resources::Languages.describe(lang)}: looking in #{model}."
            end
            silence_streams(STDOUT, STDERR) do
              @@taggers[lang] =
              MaxentTagger.new(models[0])
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
