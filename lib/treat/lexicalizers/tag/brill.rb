# Adapter class for the 'rbtagger' gem, a port
# of the Perl Lingua::BrillTagger class, based
# on the rule-based tagger developped by Eric Brill.
#
# Original paper:
#
# Eric Brill. 1992. A simple rule-based part of speech tagger.
# In Proceedings of the third conference on Applied natural
# language processing (ANLC '92). Association for Computational
# Linguistics, Stroudsburg, PA, USA, 152-155.
# DOI=10.3115/974499.974526 http://dx.doi.org/10.3115/974499.974526
#
# Project website:
#
# http://rbtagger.rubyforge.org/
module Treat::Lexicalizers::Tag::Brill

  require 'rbtagger'

  require 'treat/lexicalizers/tag/brill/patch'

  # Hold one instance of the tagger.
  @@tagger = nil

  # Tag words using a native Brill tagger.
  # Performs own tokenization.
  #
  # Options (see the rbtagger gem for more info):
  #
  # :lexicon => String (Lexicon file to use)
  # :lexical_rules => String (Lexical rule file to use)
  # :contextual_rules => String (Contextual rules file to use)
  def self.tag(entity, options = {})

    # Tokenize the sentence/phrase.
    if !entity.has_children? &&
      !entity.is_a?(Treat::Entities::Token)
      entity.tokenize(:perl, options)
    end
    
    # Create the tagger if necessary
    @@tagger ||= ::Brill::Tagger.new(options[:lexicon],
    options[:lexical_rules], options[:contextual_rules])
    
    isolated_token = entity.is_a?(Treat::Entities::Token)
    tokens = isolated_token ? [entity] : entity.tokens
    tokens_s = tokens.map { |t| t.value }
    
    tags = @@tagger.tag_tokens( tokens_s )

    pairs = tokens.zip(tags)

    pairs.each do |pair|
      pair[0].set :tag, pair[1]
      pair[0].set :tag_set, :penn
      return pair[1] if isolated_token
    end
    
    return 'S' if entity.is_a?(Treat::Entities::Sentence)
    return 'P' if entity.is_a?(Treat::Entities::Phrase)

  end

end