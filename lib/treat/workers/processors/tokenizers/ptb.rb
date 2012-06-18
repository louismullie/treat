# encoding: utf-8
# A native rule-basd tokenizer based on the one
# developped by Robert Macyntyre in 1995 for the Penn
# Treebank project. This tokenizer follows the
# conventions used by the Penn Treebank.
#
# Original script:
# http://www.cis.upenn.edu/~treebank/tokenizer.sed
#
# Copyright (c) 2004 UTIYAMA Masao <mutiyama@nict.go.jp>
# All rights reserved. This program is free software;
# you can redistribute it and/or modify it under the
# same terms as Ruby itself.
module Treat::Workers::Processors::Tokenizers::PTB
  
  # Tokenize the entity using a native rule-based algorithm.
  def self.tokenize(entity, options = {})
    
    entity.check_hasnt_children
    
    if entity.has_children?
      raise Treat::Exception,
      "Cannot tokenize an #{entity.class} " +
      "that already has children."
    end
    chunks = split(entity.to_s)
    chunks.each do |chunk|
      next if chunk =~ /([[:space:]]+)/
      entity << Treat::Entities::Token.from_string(chunk)
    end
  end
  
  # Helper method to split the string into tokens.
  def self.split(string)
    
    s = " " + string + " "
    
    # Translate some common extended ascii 
    # characters to quotes
    s.gsub!(/‘/,'`')
    s.gsub!(/’/,"'")
    s.gsub!(/“/,"``")
    s.gsub!(/”/,"''")
    
    
    s.gsub!(/\s+/," ")
    s.gsub!(/(\s+)''/,'\1"')
    s.gsub!(/(\s+)``/,'\1"')
    s.gsub!(/''(\s+)/,'"\1')
    s.gsub!(/``(\s+)/,'"\1')
    s.gsub!(/ (['`]+)([^0-9].+) /,' \1 \2 ')
    s.gsub!(/([ (\[{<])"/,'\1 `` ')
    s.gsub!(/\.\.\./,' ... ')
    s.gsub!(/[,;:@\#$%&]/,' \& ')
    s.gsub!(/([^.])([.])([\])}>"']*)[ 	]*$/,'\1 \2\3 ')
    s.gsub!(/[?!]/,' \& ')
    s.gsub!(/[\]\[(){}<>]/,' \& ')
    s.gsub!(/--/,' -- ')
    s.sub!(/$/,' ')
    s.sub!(/^/,' ')
    s.gsub!(/"/,' \'\' ')
    s.gsub!(/([^'])' /,'\1 \' ')
    s.gsub!(/'([sSmMdD]) /,' \'\1 ')
    s.gsub!(/'ll /,' \'ll ')
    s.gsub!(/'re /,' \'re ')
    s.gsub!(/'ve /,' \'ve ')
    s.gsub!(/n't /,' n\'t ')
    s.gsub!(/'LL /,' \'LL ')
    s.gsub!(/'RE /,' \'RE ')
    s.gsub!(/'VE /,' \'VE ')
    s.gsub!(/N'T /,' N\'T ')
    s.gsub!(/ ([Cc])annot /,' \1an not ')
    s.gsub!(/ ([Dd])'ye /,' \1\' ye ')
    s.gsub!(/ ([Gg])imme /,' \1im me ')
    s.gsub!(/ ([Gg])onna /,' \1on na ')
    s.gsub!(/ ([Gg])otta /,' \1ot ta ')
    s.gsub!(/ ([Ll])emme /,' \1em me ')
    s.gsub!(/ ([Mm])ore'n /,' \1ore \'n ')
    s.gsub!(/ '([Tt])is /,' \'\1 is ')
    s.gsub!(/ '([Tt])was /,' \'\1 was ')
    s.gsub!(/ ([Ww])anna /,' \1an na ')
    while s.sub!(/(\s)([0-9]+) , ([0-9]+)(\s)/, '\1\2,\3\4'); end
    s.gsub!(/\//, ' / ')
    s.gsub!(/\s+/,' ')
    s.strip!
    s.split(/\s+/)
  end
  
end