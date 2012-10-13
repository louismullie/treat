patch = false

begin
  # This whole mess is required to deal with
  # the fact that the 'rbtagger' gem defines
  # a top-level module called 'Word', which
  # will clash with the top-level class 'Word'
  # we define when syntactic sugar is enabled.
rescue TypeError
  if Treat.core.syntax.sweetened
    patch = true
    # Unset the class Word for the duration
    # of loading the tagger.
    Object.instance_eval do 
      remove_const(:Word)
    end
    retry
  else
    raise Treat::Exception,
    'Something went wrong due to a name clash with the "rbtagger" gem.' +
    'Turn off syntactic sugar to resolve this problem.'
  end
ensure
  # Reset the class Word if using syntactic sugar.
  if Treat.core.syntax.sweetened && patch
    Object.const_set(:Word, Treat::Entities::Word)
  end
end

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