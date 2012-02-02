module Treat
  module Lexicalizers
    module Tag
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
      class Lingua < Tagger
        # Require the 'engtagger' gem.
        silence_warnings { require 'engtagger' }
        # Hold the tagger.
        @@tagger = nil
        # Hold the user-set options
        @@options = {}
        # Hold the default options.
        DefaultOptions =  {
          unknown_word_tag: 'pp',  # Fix unknown word tag
          relax: false
        }
        # Tag the word using a probabilistic model taking
        # into account known words found in a lexicon and
        # the tag of the previous word.
        #
        # Options:
        # 
        # - (Boolean) :relax => Relax the Hidden Markov Model: 
        #   this may improve accuracy for uncommon words, 
        #   particularly words used polysemously.
        # - (String) :unknown_word_tag => Tag for unknown words.
        def self.tag(entity, options = {})
          options = DefaultOptions.merge(options)
          r = super(entity, options)
          return r if r && r != :isolated_word
          # Reinitialize the tagger if the options have changed.
          if options != @@options
            @@options = DefaultOptions.merge(options)
            @@tagger = nil # Reset the tagger
          end
          @@tagger ||= ::EngTagger.new(@@options)
          left_tag = @@tagger.conf[:current_tag] = 'pp'
          tokens = (r == :isolated_word) ? [entity] : entity.tokens
          tokens.each do |token|
            w = @@tagger.clean_word(token.to_s)
            t = @@tagger.assign_tag(left_tag, w)
            t = options[:unknown_word_tag] if t.nil? || t == ''
            @@tagger.conf[:current_tag] = left_tag = t
            token.set :tag, t.upcase
            token.set :tag_set, :penn
            return t.upcase if r == :isolated_word
          end
          entity.set :tag_set, :penn
          return 'P' if entity.is_a?(Treat::Entities::Phrase)
          return 'S' if entity.is_a?(Treat::Entities::Sentence)
        end
      end
    end
  end
end

=begin

CC      Conjunction, coordinating               and, or
CD      Adjective, cardinal number              3, fifteen
DET     Determiner                              this, each, some
EX      Pronoun, existential there              there
FW      Foreign words
IN      Preposition / Conjunction               for, of, although, that
JJ      Adjective                               happy, bad
JJR     Adjective, comparative                  happier, worse
JJS     Adjective, superlative                  happiest, worst
LS      Symbol, list item                       A, A.
MD      Verb, modal                             can, could, 'll
NN      Noun                                    aircraft, data
NNP     Noun, proper                            London, Michael
NNPS    Noun, proper, plural                    Australians, Methodists
NNS     Noun, plural                            women, books
PDT     Determiner, prequalifier                quite, all, half
POS     Possessive                              's, '
PRP     Determiner, possessive second           mine, yours
PRPS    Determiner, possessive                  their, your
RB      Adverb                                  often, not, very, here
RBR     Adverb, comparative                     faster
RBS     Adverb, superlative                     fastest
RP      Adverb, particle                        up, off, out
SYM     Symbol                                  *
TO      Preposition                             to
UH      Interjection                            oh, yes, mmm
VB      Verb, infinitive                        take, live
VBD     Verb, past tense                        took, lived
VBG     Verb, gerund                            taking, living
VBN     Verb, past/passive participle           taken, lived
VBP     Verb, base present form                 take, live
VBZ     Verb, present 3SG -s form               takes, lives
WDT     Determiner, question                    which, whatever
WP      Pronoun, question                       who, whoever
WPS     Determiner, possessive & question       whose
WRB     Adverb, question                        when, how, however

PP      Punctuation, sentence ender             ., !, ?
PPC     Punctuation, comma                      ,
PPD     Punctuation, dollar sign                $
PPL     Punctuation, quotation mark left        ``
PPR     Punctuation, quotation mark right       ''
PPS     Punctuation, colon, semicolon, elipsis  :, ..., -
LRB     Punctuation, left bracket               (, {, [
RRB     Punctuation, right bracket              ), }, ]

=end