module Treat::Entities::Abilities::Magical

  # Parse "magic methods", which allow the following
  # syntaxes to be used (where 'word' can be replaced
  # by any entity type, e.g. token, zone, etc.):
  #
  # - each_word : iterate over each entity of type word.
  # - words: return an array of words in the entity.
  # - word: return the first word in the entity.
  # - word_count: return the number of words in the entity.
  # - words_with_*(value) (where  is an arbitrary feature):
  #   return the words that have the given feature.
  # - word_with_*(value) : return the first word with
  #   the feature specified by * in value.
  #
  # Also provides magical methods for types of words:
  #
  # - each_noun:
  # - nouns:
  # - noun:
  # - noun_count:
  # - nouns_with_*(value)
  # - noun_with_*(value)
  #
  def magic(sym, *args)

    @@entities_regexp ||= "(#{Treat::Entities.list.join('|')})"
    @@cats_regexp ||= "(#{Treat::Languages::WordCategories.join('|')})"

    method = sym.to_s =~ /entities/ ?
    sym.to_s.gsub('entities', 'entitys') :
    method = sym.to_s

    if method =~ /^#{@@entities_regexp}s$/
      entities_with_type($1.intern)
    elsif method =~ /^#{@@entities_regexp}$/
      first_but_warn(entities_with_type($1.intern), $1)
    elsif method =~ /^parent_#{@@entities_regexp}$/
      ancestor_with_type($1.intern)
    elsif method =~ /^each_#{@@entities_regexp}$/
      each_entity($1.intern) { |e| yield e }
    elsif method =~ /^#{@@entities_regexp}_count$/
      entities_with_type($1.intern).size
    elsif method =~ /^#{@@entities_regexp}s_with_([a-z]+)$/
      entities_with_feature($2.intern, args[0], $1.intern)
    elsif method =~ /^#{@@entities_regexp}_with_([a-z]*)$/
      first_but_warn(entities_with_feature(
      $2.intern, args[0], $1.intern), $1)
    elsif method =~ /^each_#{@@entities_regexp}_with_([a-z]*)$/
      entities_with_feature($2.intern, args[0], 
      $1.intern).each { |e| yield e }
    elsif method =~ /^each_with_([a-z]*)$/
      entities_with_feature($2.intern, 
      args[0], $1.intern).each { |e| yield e }
    elsif method =~ /^each_#{@@cats_regexp}$/
      entities_with_category($1.intern
      ).each { |e| yield e }
    elsif method =~ /^#{@@cats_regexp}s$/
      entities_with_category($1.intern)
    elsif method =~ /^#{@@cats_regexp}$/
     first_but_warn(entities_with_category($1.intern), $1)
    elsif method =~ /^#{@@cats_regexp}_count$/
      entities_with_category($1.intern).size
    elsif method =~ /^#{@@cats_regexp}s_with_([a-z]*)$/
      entities_with_feature($2.intern, args[0], $1)
    elsif method =~ /^#{@@cats_regexp}_with_([a-z]*)$/
      first_but_warn(entities_with_feature(
      $2.intern, args[0], $1.intern), $1)
    elsif method =~ /^([a-z]*)_of_first_#{@@entities_regexp}$/
      f = send(:"#{$2}s".intern).first
      f ? f.send($1.intern) : nil
    elsif method =~ /^is_#{@@entities_regexp}\?$/
      type.to_s == $1.intern
    elsif method =~ /^is_#{@@cats_regexp}\?$/
      category.to_s == $1.intern
    elsif method =~ /^frequency_in_#{@@entities_regexp}$/
      frequency_in($1.intern)
    elsif method =~ /^position_in_#{@@entities_regexp}$/
      position_in($1.intern)
    elsif method =~ /^position_from_end_of_#{@@entities_regexp}$/
      position_from_end_of($1.intern)
      # first_word
      # tag_of_first_verb
      # tag_of_title
    else
      return :no_magic
    end
  end
  
end