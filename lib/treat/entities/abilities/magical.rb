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

    # Cache this for performance.
    @@entities_regexp ||= "(#{Treat.core.entities.list.join('|')})"
    @@cats_regexp ||= "(#{Treat.linguistics.categories.join('|')})"

    method = sym.to_s =~ /entities/ ?
    sym.to_s.gsub('entities', 'entitys') :
    method = sym.to_s

    if method =~ /^#{@@entities_regexp}s$/
      entities_with_type($1.intern)
    elsif method =~ /^#{@@entities_regexp}$/
      first_but_warn(entities_with_type($1.intern), $1)
    elsif method =~ /^first_#{@@entities_regexp}$/
      e = entities_with_type($1.intern)
      e ? e[0] : nil
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
      entities_with_category($1).each { |e| yield e }
    elsif method =~ /^#{@@cats_regexp}s$/
      entities_with_category($1)
    elsif method =~ /^#{@@cats_regexp}$/
     first_but_warn(entities_with_category($1), $1)
    elsif method =~ /^first_#{@@cats_regexp}$/
     e = entities_with_category($1)
     e ? e[0] : nil
    elsif method =~ /^#{@@cats_regexp}_count$/
      entities_with_category($1).size
    elsif method =~ /^(.*)_count$/
      num_children_with_feature($1.intern)
    elsif method =~ /^#{@@cats_regexp}s_with_([a-z]*)$/
      entities_with_feature($2.intern, args[0], $1)
    elsif method =~ /^#{@@cats_regexp}_with_([a-z]*)$/
      first_but_warn(entities_with_feature(
      $2.intern, args[0], $1.intern), $1)
    elsif method =~ /^([a-z]*)_of_(.*)$/
      f = send($2.intern)
      f ? f.send($1.intern) : nil
    elsif method =~ /^frequency_in_#{@@entities_regexp}$/
      frequency_in($1.intern)
    else
      return :no_magic
    end
  end
  
  
end