Brill::Tagger.class_eval do 

  def tag_tokens(tokens)
    
    tags = Brill::Tagger.tag_start( tokens )

    @tagger.apply_lexical_rules( tokens, tags, [], 0 )
    @tagger.default_tag_finish( tokens, tags )

    # Brill uses these fake "STAART" tags to delimit the start & end of sentence.
    tokens << "STAART"
    tokens << "STAART"
    tokens.unshift "STAART"
    tokens.unshift "STAART"
    tags << "STAART"
    tags << "STAART"
    tags.unshift "STAART"
    tags.unshift "STAART"

    @tagger.apply_contextual_rules( tokens, tags, 1 )

    tags.shift
    tags.shift
    tokens.shift
    tokens.shift
    tags.pop
    tags.pop
    tokens.pop
    tokens.pop

    tags
    
  end
  
end