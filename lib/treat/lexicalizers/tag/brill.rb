module Treat
  module Lexicalizers
    module Tag
      # Adapter class for the 'rbtagger' gem, a port
      # of the Perl Lingua::BrillTagger class, based
      # on the rule-based tagger developped by Eric Brill.
      #
      # The Brill tagger is a simple rule-based part of
      # speech tagger. The main advantages over stochastic
      # taggers is a vast reduction in information required
      # and better portability from one tag set, corpus genre
      # or language to another.
      #
      # Original paper:
      # Eric Brill. 1992. A simple rule-based part of speech tagger.
      # In Proceedings of the third conference on Applied natural
      # language processing (ANLC '92). Association for Computational
      # Linguistics, Stroudsburg, PA, USA, 152-155.
      # DOI=10.3115/974499.974526 http://dx.doi.org/10.3115/974499.974526
      # Project website:
      # http://rbtagger.rubyforge.org/
      # Original Perl module site:
      # http://search.cpan.org/~kwilliams/Lingua-BrillTagger-0.02/lib/Lingua/BrillTagger.pm
      class Brill < Tagger
        patch = false
        # Require the 'rbtagger' gem.
        require 'rbtagger'
        begin
          # This whole mess is required to deal with
          # the fact that the 'rbtagger' gem defines
          # a top-level module called 'Word', which
          # will clash with the top-level class 'Word'
          # we define when syntactic sugar is enabled.
        rescue TypeError
          if Treat.edulcorated?
            patch = true
            # Unset the class Word for the duration
            # of loading the tagger.
            Object.const_unset(:Word); retry
          else
            raise Treat::Exception,
            'Something went wrong due to a name clash with the "rbtagger" gem.' +
            'Turn off syntactic sugar to resolve this problem.'
          end
        ensure
          # Reset the class Word if using syntactic sugar.
          if Treat.edulcorated? && patch
            Object.const_set(:Word, Treat::Entities::Word)
          end
        end
        # Hold the tagger.
        @@tagger = nil
        # Hold the user-set options
        @@options = {}
        # Tag words using a native Brill tagger.
        #
        # Options:
        #
        # :lexicon => String (Lexicon file to use)
        # :lexical_rules => String (Lexical rule file to use)
        # :contextual_rules => String (Contextual rules file to use)
        def self.tag(entity, options = {})
          r = super(entity, options)
          return r if r && r != :isolated_word
          # Reinitialize the tagger if the options have changed.
          @@tagger = nil if options != @@options
          # Create the tagger if necessary
          @@tagger ||= ::Brill::Tagger.new(options[:lexicon],
          options[:lexical_rules], options[:contextual_rules])
          words = (r == :isolated_word) ? [entity] : entity.tokens
          res = @@tagger.tag(words.join(' '))[1..-1]
          res ||= []
          res.each do |info|
            words.each do |word|
              if word.value == info[0]
                word.set :tag_set, :penn
                word.set :tag, info[1]
                return info[1] if r == :isolated_word
              end
            end
          end
          entity.set :tag_set, :penn
          return 'P' if entity.type == :phrase
          return 'S' if entity.type == :sentence
        end
      end
    end
  end
end
