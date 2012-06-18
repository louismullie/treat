# A cache to optimize camel casing.
@@cc_cache = {}

# A cache to optimize un camel casing.
@@ucc_cache = {}

# Convert un_camel_case to CamelCase.
def camel_case(o_phrase)
  phrase = o_phrase.to_s.dup
  return @@cc_cache[o_phrase] if @@cc_cache[o_phrase]

  if Treat.core.acronyms.include?(phrase)
    phrase = phrase.upcase
  else
    phrase.gsub!(/^[a-z]|_[a-z]/) { |a| a.upcase }
    phrase.gsub!('_', '')
  end
  @@cc_cache[o_phrase] = phrase
end

alias :cc :camel_case

# Convert CamelCase to un_camel_case.
def un_camel_case(o_phrase)
  phrase = o_phrase.to_s.dup
  return @@ucc_cache[o_phrase] if @@ucc_cache[o_phrase]
  if Treat.core.acronyms.include?(phrase.downcase)
    phrase = phrase.downcase
  else
    phrase.gsub!(/[A-Z]/) { |p| '_' + p.downcase  }
    phrase = phrase[1..-1] if phrase[0] == '_'
  end
  @@ucc_cache[o_phrase] = phrase
end

alias :ucc :un_camel_case

# Retrieve the Class from a Module::Class.
def class_name(n); n.to_s.split('::')[-1]; end

alias :cl :class_name