# encoding: utf-8
#
# Tokenize the entity using a native rule-based 
# algorithm. This tokenizer is a port from an 
# unknown Perl module, which I have lifted from 
# the 'rbtagger' gem.
#
# Author: Todd A. Fisher
# 
# This code is free to use under the terms of 
# the MIT license.
#
# Original project website:
# 
# https://github.com/taf2/rb-brill-tagger
module Treat::Processors::Tokenizers::Perl

  require 'treat/helpers/decimal_point_escaper'
  
  # Tokenize the entity using a rule-based algorithm
  # ported from Perl by Todd A. Fisher.
  #
  # Options: none.
  def self.tokenize(entity, options = {})
    
    entity.check_hasnt_children
    s = entity.to_s
    
    tokens = get_tokens(entity.to_s)
    tokens[1..-1].each do |token|
      next if token =~ /^\s*$/
      entity << Treat::Entities::Token.
      from_string(token)
    end

  end

  # Helper method to perform the tokenization.
  def self.get_tokens(string)

    # Normalize all whitespace
    text = string.gsub(/\s+/,' ')
    
    # Replace all decimal points by ^^
    Treat::Helpers::DecimalPointEscaper.escape!(text)
    
=begin

    # Translate some common extended ascii 
    # characters to quotes
    text.gsub!(/‘/,'`')
    text.gsub!(/’/,"'")
    text.gsub!(/“/,"``")
    text.gsub!(/”/,"''")

    # Attempt to get correct directional quotes
    # s{\"\b} { `` }g;
    text.gsub!(/\"\b/,' `` ')
    # s{\b\"} { '' }g;
    text.gsub!(/\b\"/," '' ")
    #s{\"(?=\s)} { '' }g;
    text.gsub!(/\"(?=\s)/," '' ")
    #s{\"} { `` }g;
    text.gsub!(/\"(?=\s)/," `` ")
=end

    # Isolate ellipses
    # s{\.\.\.}   { ... }g;
    text.gsub!(/\.\.\./,' ... ')
    # Isolate any embedded punctuation chars
    #   s{([,;:\@\#\$\%&])} { $1 }g;
    text.gsub!(/([,;:\@\#\$\%&])/, ' \1 ')

    # Assume sentence tokenization has been 
    # done first, so split FINAL
    # periods only.
    # s/ ([^.]) \.  ([\]\)\}\>\"\']*) 
    # [ \t]* $ /$1 .$2 /gx;
    text.gsub!(/ ([^.]) \.  ([\]\)\}\>\"\']*) [ \t]* $ /x, '\1 .\2 ')
    # however, we may as well split ALL 
    # question marks and exclamation points,
    # since they shouldn't have the abbrev.
    # -marker ambiguity problem
    #s{([?!])} { $1 }g;
    text.gsub!(/([?!])/, ' \1 ')
    # parentheses, brackets, etc.
    #s{([\]\[\(\)\{\}\<\>])} { $1 }g;
    text.gsub!(/([\]\[\(\)\{\}\<\>])/,' \1 ')
    #s/(-{2,})/ $1 /g;
    text.gsub!(/(-{2,})/,' \1 ')

    # Add a space to the beginning and end of 
    # each line, to reduce # of regexps below.
    #s/$/ /;
    text.gsub!(/$/," ")
    #s/^/ /;
    text.gsub!(/^/," ")

    # possessive or close-single-quote
    #s/\([^\']\)\' /$1 \' /g;
    text.gsub!(/\([^\']\)\' /,%q(\1 ' ))
    # as in it's, I'm, we'd
    #s/\'([smd]) / \'$1 /ig;
    text.gsub!(/\'([smd]) /i,%q( '\1 ))
    #s/\'(ll|re|ve) / \'$1 /ig;
    text.gsub!(/\'(ll|re|ve) /i,%q( '\1 ))
    #s/n\'t / n\'t /ig;
    text.gsub!(/n\'t /i,"  n't ")

    #s/ (can)(not) / $1 $2 /ig;
    text.gsub!(/ (can)(not) /i,' \1 \2 ')
    #s/ (d\')(ye) / $1 $2 /ig;
    text.gsub!(/ (d\')(ye) /i,' \1 \2 ')
    #s/ (gim)(me) / $1 $2 /ig;
    text.gsub!(/ (gim)(me) /i,' \1 \2 ')
    #s/ (gon)(na) / $1 $2 /ig;
    text.gsub!(/ (gon)(na) /i,' \1 \2 ')
    #s/ (got)(ta) / $1 $2 /ig;
    text.gsub!(/ (got)(ta) /i,' \1 \2 ')
    #s/ (lem)(me) / $1 $2 /ig;
    text.gsub!(/ (lem)(me) /i,' \1 \2 ')
    #s/ (more)(\'n) / $1 $2 /ig;
    text.gsub!(/ (more)(\'n) /i,' \1 \2 ')
    #s/ (\'t)(is|was) / $1 $2 /ig;
    text.gsub!(/ (\'t)(is|was) /i,' \1 \2 ')
    #s/ (wan)(na) / $1 $2 /ig;
    text.gsub!(/ (wan)(na) /i,' \1 \2 ')
    text.split(/\s/)

  end

end
