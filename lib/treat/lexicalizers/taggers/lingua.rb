# An adapter for the 'engtagger' gem, which
# is a port of the Perl Lingua::EN::Tagger module.
#
# "This module uses part-of-speech statistics from
# the Penn Treebank to assign POS tags to English text.
# The tagger applies a bigram (two-word) Hidden Markov
# Model to guess the appropriate POS tag for a word.
# That means that the tagger will try to assign a POS
# tag based on the known POS tags for a given word and
# the POS tag assigned to its predecessor.
#
# Project website: http://engtagger.rubyforge.org/
# Original Perl module site:
# http://cpansearch.perl.org/src/ACOBURN/Lingua-EN-Tagger-0.15/
class Treat::Lexicalizers::Taggers::Lingua
  
  # Require the 'engtagger' gem.
  silence_warnings { require 'engtagger' }
  
  # Undefine the porter stemming business.
  String.class_eval { undef :stem }
  
  # Hold one instance of the tagger.
  @@tagger = nil
  
  # Hold the default options.
  DefaultOptions =  { :relax => false }
  
  # Replace punctuation tags used by this gem
  # to the standard PTB tags.
  Punctuation = {
    'pp' => '.',
    'pps' => ';',
    'ppc' => ',',
    'ppd' => '$',
    'ppl' => 'lrb',
    'ppr' => 'rrb'
  }
  
  # Tag the word using a probabilistic model taking
  # into account known words found in a lexicon and
  # the tag of the previous word.
  #
  # Options:
  #
  # - (Boolean) :relax => Relax the HMM model -
  #   this may improve accuracy for uncommon words,
  #   particularly words used polysemously.
  def self.tag(entity, options = {})
    
    options = DefaultOptions.merge(options)
    
    @@tagger ||= ::EngTagger.new(options)
    left_tag = @@tagger.conf[:current_tag] = 'pp'
    isolated_token = entity.is_a?(Treat::Entities::Token)
    tokens = isolated_token ? [entity] : entity.tokens
    
    tokens.each do |token|
      next if token.to_s == ''
      w = @@tagger.clean_word(token.to_s)
      t = @@tagger.assign_tag(left_tag, w)
      t = 'fw' if t.nil? || t == ''
      @@tagger.conf[:current_tag] = left_tag = t
      t = 'prp$' if t == 'prps'
      t = 'dt' if t == 'det'
      t = Punctuation[t] if Punctuation[t]
      token.set :tag, t.upcase
      token.set :tag_set, :penn if isolated_token
      return t.upcase if isolated_token
      
    end

    
    if entity.is_a?(Treat::Entities::Sentence) ||
      (entity.is_a?(Treat::Entities::Phrase) && 
      !entity.parent_sentence)
        entity.set :tag_set, :penn
    end

    return 'S' if entity.is_a?(Treat::Entities::Sentence)
    return 'P' if entity.is_a?(Treat::Entities::Phrase)
    
  end
  
end