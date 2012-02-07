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
      class Brill
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
          if Treat.sweetened?
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
          if Treat.sweetened? && patch
            Object.const_set(:Word, Treat::Entities::Word)
          end
        end
        # Hold the tagger.
        @@tagger = nil
        # Tag words using a native Brill tagger.
        # Performs own tokenization.
        #
        # Options:
        #
        # :lexicon => String (Lexicon file to use)
        # :lexical_rules => String (Lexical rule file to use)
        # :contextual_rules => String (Contextual rules file to use)
        def self.tag(entity, options = {})
          if entity.has_children?
            warn "The Brill tagger performs its own tokenization. " +
                 "Removing all children of #{entity.type} with value #{entity.short_value}."
            entity.remove_all!
          end
          # Create the tagger if necessary
          @@tagger ||= ::Brill::Tagger.new(options[:lexicon],
          options[:lexical_rules], options[:contextual_rules])
          res = @@tagger.tag(entity.to_s)
          res ||= []
          isolated_word = entity.is_a?(Treat::Entities::Token)
          res.each do |info|
            next if info[1] == ')'
            token = Treat::Entities::Token.from_string(info[0])
            token.set :tag_set, :penn
            token.set :tag, info[1]
            if isolated_word
              entity.set :tag_set, :penn
              return info[1]
            end
            entity << token
          end
          entity.set :tag_set, :penn
          return 'P' if entity.is_a?(Treat::Entities::Phrase)
          return 'S' if entity.is_a?(Treat::Entities::Sentence)
        end
      end
    end
  end
end
