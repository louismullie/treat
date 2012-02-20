# A tokenizer class lifted from the 'tactful-tokenizer' gem.
#
# Copyright © 2010 Matthew Bunday. All rights reserved.
# Released under the GNU GPL v3. Modified by Louis Mullie.
#
# Project website: https://github.com/SlyShy/Tactful_Tokenizer
class Treat::Processors::Tokenizers::Tactful


  ReTokenize = [
    # Uniform Quotes
    [/''|``/, '"'],
    # Separate punctuation from words.
    [/(^|\s)(')/, '\1\2'],
    [/(?=[\("`{\[:;&#*@\.])(.)/, '\1 '],
    [/(.)(?=[?!\)";}\]*:@\.'])|(?=[\)}\]])(.)|(.)(?=[({\[])|((^|\s)-)(?=[^-])/, '\1 '],
    # Treat double-hyphen as a single token.
    [/([^-])(--+)([^-])/, '\1 \2 \3'],
    [/(\s|^)(,)(?=(\S))/, '\1\2 '],
    # Only separate a comma if a space follows.
    [/(.)(,)(\s|$)/, '\1 \2\3'],
    # Combine dots separated by whitespace to be a single token.
    [/\.\s\.\s\./, '...'],
    # Separate "No.6"
    [/([\W]\.)(\d+)/, '\1 \2'],
    # Separate words from ellipses
    [/([^\.]|^)(\.{2,})(.?)/, '\1 \2 \3'],
    [/(^|\s)(\.{2,})([^\.\s])/, '\1\2 \3'],
    [/(^|\s)(\.{2,})([^\.\s])/, '\1 \2\3'],
    ##### Some additional fixes.
    # Fix %, $, &
    [/(\d)%/, '\1 %'],
    [/\$(\.?\d)/, '$ \1'],
    [/(\W)& (\W)/, '\1&\2'],
    [/(\W\W+)&(\W\W+)/, '\1 & \2'],
    # Fix (n 't) -> ( n't)
    [/n 't( |$)/, " n't\\1"],
    [/N 'T( |$)/, " N'T\\1"],
    # Treebank tokenizer special words
    [/([Cc])annot/, '\1an not']

  ]


  # Tokenize the entity using a rule-based algorithm
  # that has been lifted from the 'tactful-tokenizer'
  # gem.
  def self.tokenize(entity, options = {})
    
    entity.check_hasnt_children
    
    s = entity.to_s
    ReTokenize.each do |rules|
      s.gsub!(rules[0], rules[1])
    end
    
    s.split(' ').each do |token|
      entity << Treat::Entities::Token.from_string(token)
    end
    
  end

end
