module Treat
  module Processors
    module Tokenizers
      # A tokenizer that was lifted from the 'punkt-segmenter'
      # Ruby gem.
      #
      # This code follows the terms and conditions of Apache 
      # License v2 (http://www.apache.org/licenses/LICENSE-2.0)
      #
      # Authors: Willy <willy@csse.unimelb.edu.au>
      # (original Python port), Steven Bird
      # <sb@csse.unimelb.edu.au> (additions),
      # Edward Loper <edloper@gradient.cis.upenn.edu>
      # (rewrite), Joel Nothman <jnothman@student.usyd.edu.au>
      # (almost rewrite).
      #
      # Project website: https://github.com/lfcipriani/punkt-segmenter
      class Punkt
        SentEndChars = ['.', '?', '!']
        ReSentEndChars = /[.?!]/
        InternalPunctuation = [',', ':', ';']
        ReBoundaryRealignment = /^["\')\]}]+?(?:\s+|(?=--)|$)/m
        ReWordStart = /[^\(\"\`{\[:;&\#\*@\)}\]\-,]/
        ReNonWordChars = /(?:[?!)\";}\]\*:@\'\({\[])/
        ReMultiCharPunct = /(?:\-{2,}|\.{2,}|(?:\.\s){2,}\.)/
        ReWordTokenizer = /#{ReMultiCharPunct}|(?=#{ReWordStart})\S+?(?=\s|$|#{ReNonWordChars}|#{ReMultiCharPunct}|,(?=$|\s|#{ReNonWordChars}|#{ReMultiCharPunct}))|\S/
        RePeriodContext = /\S*#{ReSentEndChars}(?=(?<after_tok>#{ReNonWordChars}|\s+(?<next_tok>\S+)))/
        # Tokenize the text using the algorithm lifted from
        # the Punkt tokenizer.
        #
        # Options: none.
        def self.tokenize(entity, options = {})
          entity.to_s.scan(ReWordTokenizer).each do |token|
            puts token
            entity << Treat::Entities::Entity.from_string(token)
          end
          entity
        end
      end
    end
  end
end
