module Treat
  module Lexicalizers
    module Tag
      class Stanford < Tagger
        require 'stanford-core-nlp'
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
        DefaultOptions =  {silence: false, log_to_file: nil}
        # Tag the word using one of the Stanford taggers.
        def self.tag(entity, options = {})
          options = DefaultOptions.merge(options)
          
          t = super(entity, options)
          return r if r && r != :isolated_word

          # Arrange options.
          lang = entity.language
          model = options[:model]
          unless model
            model = LanguageToModel[lang]
            if model.nil?
              raise Treat::Exception, "There exists no Stanford tagger model for " +
              "the #{Treat::Languages.describe(lang)} language ."
            end
          end
          # Set the tagger model.
          StanfordCoreNLP.set_model('tagger.model', model)
          
          # Reinitialize the tagger if the options have changed.
          if options != @@options[lang]
            @@options[lang] = DefaultOptions.merge(options)
            @@taggers[lang] = nil  # Reset the tagger
            options[:log_to_file] = '/dev/null' if options[:silence]
            ::StanfordCoreNLP.log_file = options[:log_to_file] if options[:log_to_file]
          end
          
          # Load the tagger.
          @@taggers[lang] ||= ::StanfordCoreNLP.load(:tokenize, :ssplit, :pos)
          
          # Tag the text.
          text = ::StanfordCoreNLP::Text.new(entity.to_s)
          @@taggers[lang].annotate(text)

          # Realign the tags.
          entity.each_token do |t1|
            text.get(:sentences).each do |sentence|
              sentence.get(:tokens).each do |t2|
                if t2.value == t1.value
                  tag = t2.get(:part_of_speech).to_s
                  t1.set :tag, tag
                  t1.set :tag_set, :penn
                  return tag if r == :isolated_word
                  break
                end
              end
            end
          end
          
          # Handle tags for sentences and phrases.
          entity.set :tag_set, :penn
          return 'P' if entity.type == :phrase
          return 'S' if entity.type == :sentence
        end
      end
    end
  end
end

=begin

  list = StanfordCoreNLP::ArrayList.new
  id_list = {}
  i = 0
  if entity.type == :word
    ps = entity.parent_sentence
    entities = ps.words if ps
    pc = entity.parent_phrase
    entities = pc.words if pc
    entities = [entity] unless pc
  else
    entities = entity.words
  end
  entities.each do |word|    # Fix...
    list.add(StanfordCoreNLP::Word.new(word.to_s))
    id_list[i] = word
    i += 1
  end
  it = nil
  it = @@taggers[lang].apply(list).iterator
  i = 0
  while it.has_next
    w = it.next
    id_list[i].set :tag_set, :penn
    id_list[i].set :tag, w.tag
    i += 1
  end
  w.tag
end
=end
