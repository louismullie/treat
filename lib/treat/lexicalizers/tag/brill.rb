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
  
  require 'treat/processors/lexicalizers/tag/brill/patch'
  
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
    
    if entity.has_children?
      warn "The Brill tagger performs its own tokenization. " +
      "Removing all children of #{entity.type} with value "+
      "#{entity.short_value}."
      entity.remove_all!
    end
    
    # Create the tagger if necessary
    @@tagger ||= ::Brill::Tagger.new(options[:lexicon],
    options[:lexical_rules], options[:contextual_rules])
    res = @@tagger.tag(entity.to_s)
    res ||= []
    isolated_token = entity.is_a?(Treat::Entities::Token)
    
    res.each do |info|
      next if info[1] == ')'
      token = Treat::Entities::Token.from_string(info[0])
      token.set :tag_set, :penn
      token.set :tag, info[1]
      if isolated_token
        entity.set :tag_set, :penn
        return info[1]
      end
      entity << token
    end
    
    entity.set :tag_set, :penn
    
    return 'S' if entity.is_a?(Treat::Entities::Sentence)
    return 'P' if entity.is_a?(Treat::Entities::Phrase)
    
  end

end