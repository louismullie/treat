# Tokenization script from the 'punkt-segmenter' Ruby gem.
#
# Authors: Willy (willy@csse.unimelb.edu.au>), 
# Steven Bird (sb@csse.unimelb.edu.au), Edward Loper 
# (edloper@gradient.cis.upenn.edu), Joel Nothman 
# (jnothman@student.usyd.edu.au).
# License: Apache License v2.
class Treat::Workers::Processors::Tokenizers::Punkt
  SentEndChars = ['.', '?', '!']
  ReSentEndChars = /[.?!]/
  InternalPunctuation = [',', ':', ';']
  ReBoundaryRealignment = /^["\')\]}]+?(?:\s+|(?=--)|$)/m
  ReWordStart = /[^\(\"\`{\[:;&\#\*@\)}\]\-,]/
  ReNonWordChars = /(?:[?!)\";}\]\*:@\'\({\[])/
  ReMultiCharPunct = /(?:\-{2,}|\.{2,}|(?:\.\s){2,}\.)/
  ReWordTokenizer = /#{ReMultiCharPunct}|(?=#{ReWordStart})\S+?(?=\s|$|#{ReNonWordChars}|#{ReMultiCharPunct}|,(?=$|\s|#{ReNonWordChars}|#{ReMultiCharPunct}))|\S/
  RePeriodContext = /\S*#{ReSentEndChars}(?=(?<after_tok>#{ReNonWordChars}|\s+(?<next_tok>\S+)))/
  
  # Perform tokenization of the entity and add
  # the resulting tokens as its children.
  #
  # Options: none.
  def self.tokenize(entity, options = {})
    
    entity.check_hasnt_children
    
    s = entity.to_s
    
    s.scan(ReWordTokenizer).each do |token|
      if SentEndChars.include?(token[-1])
        entity << Treat::Entities::
        Token.from_string(token[0..-2])
        entity << Treat::Entities::
        Token.from_string(token[-1..-1])
      else
        entity << Treat::Entities::
        Token.from_string(token)
      end
    end
    
  end
  
end