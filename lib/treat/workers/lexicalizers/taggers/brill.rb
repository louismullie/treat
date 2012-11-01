# POS tagging using a set of rules developped by Eric Brill.
#
# Original paper: Eric Brill. 1992. A simple rule-based 
# part of speech tagger. In Proceedings of the third
# conference on Applied natural language processing.
class Treat::Workers::Lexicalizers::Taggers::Brill

  require 'rbtagger'

  require_relative 'brill/patch'

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
      pair[0].set :tag_set, :penn if isolated_token
      return pair[1] if isolated_token
    end
    
    if entity.is_a?(Treat::Entities::Group) && 
      !entity.parent_sentence)
        entity.set :tag_set, :penn
    end
    
    return 'S' if entity.is_a?(Treat::Entities::Sentence)
    return 'P' if entity.is_a?(Treat::Entities::Phrase)

  end

end