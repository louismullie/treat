# Helper methods for camel casing and 
# escaping standard strings and symbols.
class Treat::Helpers::String

  # Utility to escape floating point numbers
  # from strings (useful for a variety of 
  # applications, including chunking, segmenting
  # and tokenizing, to exclude periods that 
  # are not sentence terminators).
  module Escapable
    
    # Escape char to use.
    EscapeChar = '^^^'
    # Regex for escape.
    Regex = /([0-9]+)\.([0-9]+)/
    
    # Escape float periods with EscapeChar.
    def escape_floats!
      to_s.gsub!(Regex) { $1 + EscapeChar + $2 }
    end
    
  end

  # Counterpart to Treat::Helpers::Escapable;
  # unescapes floats, restoring the orgiinal text.
  module Unescapable
    
    # Escaped for regex.
    EscapedEscapeChar = '\^\^\^'
    # Regex for unescape.
    Regex = /([0-9]+)#{EscapedEscapeChar}([0-9]+)/
    
    # Unescape float periods (restore text).
    def unescape_floats!
      to_s.gsub!(Regex) { $1 + '.' + $2 }
    end
    
  end
  
  # Transform an un_camel_cased string
  # into a CamelCased string. This is
  # available on String and Symbol.
  module CamelCaseable

    # A cache to optimize camel casing.
    @@cc_cache = {}
    
    # Regex for camel casing.
    Regex = /^[a-z]|_[a-z]/
    
    # Convert un_camel_case to CamelCase.
    def camel_case
      o_phrase, phrase = to_s, to_s.dup
      if @@cc_cache[o_phrase]
        return @@cc_cache[o_phrase] 
      end
      if Treat.core.acronyms.include?(phrase)
        phrase = phrase.upcase
      else
        phrase.gsub!(Regex) { |a| a.upcase }
        phrase.gsub!('_', '')
      end
      @@cc_cache[o_phrase] = phrase
    end

    alias :cc :camel_case

  end

  # Counterpart of Treat::Helpers::CamelCaseable;
  # transforms a CamelCase string to its un_camel_
  # case corresponding form.
  module UnCamelCaseable
    
    # A cache to optimize un camel casing.
    @@ucc_cache = {}

    # Convert CamelCase to un_camel_case.
    def un_camel_case
      o_phrase, phrase = to_s, to_s.dup
      if @@ucc_cache[o_phrase]
        return @@ucc_cache[o_phrase] 
      end
      acros = Treat.core.acronyms
      if !acros.include?(phrase.downcase)
        phrase.gsub!(/[A-Z]/) do |p| 
          '_' + p.downcase
        end
        if phrase[0] == '_'
          return phrase = phrase[1..-1] 
        end
      else
        phrase = phrase.downcase
      end
      @@ucc_cache[o_phrase] = phrase
    end

    alias :ucc :un_camel_case
  
  end
  
  # Determines whether module is 
  # an "-able" mixin kind of thing.
  module IsMixin
    def is_mixin?; to_s[-4..-1] == 'able'; end
  end
  
  # Graft the helpers onto the string module.
  String.class_eval do
    include Treat::Helpers::String::CamelCaseable
    include Treat::Helpers::String::UnCamelCaseable
    include Treat::Helpers::String::Escapable
    include Treat::Helpers::String::Unescapable
    include Treat::Helpers::String::IsMixin
  end
  
  # Graft camel casing onto symbols.
  Symbol.class_eval do
    include Treat::Helpers::String::CamelCaseable
    include Treat::Helpers::String::UnCamelCaseable
  end
  
  
end
