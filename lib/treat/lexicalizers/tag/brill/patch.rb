patch = false

begin
  # This whole mess is required to deal with
  # the fact that the 'rbtagger' gem defines
  # a top-level module called 'Word', which
  # will clash with the top-level class 'Word'
  # we define when syntactic sugar is enabled.
rescue TypeError
  if Treat.sweetened?
    patch = true
    # Unset the class Word for the duration
    # of loading the tagger.
    Object.const_unset(:Word); retry
  else
    raise Treat::Exception,
    'Something went wrong due to a name clash with the "rbtagger" gem.' +
    'Turn off syntactic sugar to resolve this problem.'
  end
ensure
  # Reset the class Word if using syntactic sugar.
  if Treat.sweetened? && patch
    Object.const_set(:Word, Treat::Entities::Word)
  end
end