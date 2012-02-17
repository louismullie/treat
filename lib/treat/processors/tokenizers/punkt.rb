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
class Treat::Processors::Tokenizers::Punkt
  
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
  # the Punkt tokenizer gem.
  #
  # Options: none.
  def self.tokenize(entity, options = {})
    
    Treat::Processors.warn_if_has_children(entity)
    
    entity.to_s.scan(ReWordTokenizer).each do |token|
      if SentEndChars.include?(token[-1])
        entity << Treat::Entities::Token.from_string(token[0..-2])
        entity << Treat::Entities::Token.from_string(token[-1..-1])
      else
        entity << Treat::Entities::Token.from_string(token)
      end
    end
    
  end
  
end