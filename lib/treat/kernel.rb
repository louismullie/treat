# Extends the core Kernel module to provide
# easy access to utility functions used across
# the library.
module Kernel
  require 'fileutils'
  require 'tempfile'
  # A list of acronyms used in class names within
  # the program. These do not CamelCase; they
  # CAMELCase.
  Acronyms = ['XML', 'HTML', 'YAML', 'UEA', 'LDA', 'PDF', 'GOCR'].join('|')
  # A cache to optimize camel casing.
  @@cc_cache = {}
  # A cache to optimize un camel casing.
  @@ucc_cache = {}
  # Returns the platform we are running on.
  def platform
    RUBY_PLATFORM.split("-")[1]
  end
  # Runs a block of code without warnings.
  def silence_warnings(&block)
    warn_level = $VERBOSE
    $VERBOSE = nil
    result = block.call
    $VERBOSE = warn_level
    result
  end
  # Runs a block of code while blocking
  # stdout. Currently not implemented.
  def silence_streams(*streams)
    yield
  end
  # Create a temporary file which is deleted
  # after execution of the block.
  def create_temp_file(ext, value = nil, &block)
    File.open("../tmp/#{Random.rand(10000000).to_s}.#{ext}", 'w') do |f| 
      f.write(value) if value 
      block.call(f.path)
    end
  end
  # Convert un_camel_case to CamelCase.
  def camel_case(o_phrase)
    phrase = o_phrase.to_s.dup
    return @@cc_cache[o_phrase] if @@cc_cache[o_phrase]
    phrase.gsub!(/#{Acronyms.downcase}[^a-z]+/) { |a| a.upcase }
    phrase.gsub!(/^[a-z]|_[a-z]/) { |a| a.upcase }
    phrase.gsub!('_', '')
    @@cc_cache[o_phrase] = phrase
    phrase
  end
  alias :cc :camel_case
  # Convert CamelCase to un_camel_case.
  def un_camel_case(o_phrase)
    phrase = o_phrase.to_s.dup
    return @@ucc_cache[o_phrase] if @@ucc_cache[o_phrase]
    phrase.gsub!(/#{Acronyms}/) { |a| a.downcase.capitalize }
    phrase.gsub!(/[A-Z]/) { |p| '_' + p.downcase  }
    phrase = phrase[1..-1] if phrase[0] == '_'
    @@ucc_cache[o_phrase] = phrase
    phrase
  end
  alias :ucc :un_camel_case
  # Retrieve the Class from a Module::Class.
  def class_name(n); n.to_s.split('::')[-1]; end
  alias :cl :class_name
  # Search the list to see if there are words similar to #name
  # in the #list If yes, return a string saying "Did you mean 
  # ... ?" with the names.
  def did_you_mean?(list, name)
    msg = ''
    sugg = []
    list.each do |element|
      l = levenshtein(element,name)
      if  l > 0 && l < 2
        sugg << element
      end
    end
    unless sugg.empty?
      if sugg.size == 1
        msg += " Perhaps you meant '#{sugg[0]}' ?"
      else
        sugg_quote = sugg[0..-2].map {|x| '\'' + x + '\''}
        msg += " Perhaps you meant #{sugg_quote.join(', ')}," +
        " or '#{sugg[-1]}' ?"
      end
    end
    msg
  end
  alias :dym? :did_you_mean?
  # Return the name of the method that called the method
  # that calls this method.
  def caller_method(n = 3)
    at = caller(n).first
    /^(.+?):(\d+)(?::in `(.*)')?/ =~ at
    :"#{Regexp.last_match[3]}"
  end
  alias :cm :caller_method
  # Return the levensthein distance between two stringsm
  # taking into account the costs of insertion, deletion,
  # and substitution. Stolen from:
  # http://ruby-snippets.heroku.com/string/levenshtein-distance
  # Used by did_you_mean?
  def levenshtein(first, other, ins=1, del=1, sub=1)
    return nil if first.nil? || other.nil?
    dm = []
    dm[0] = (0..first.length).collect { |i| i * ins}
    fill = [0] * (first.length - 1)
    for i in 1..other.length
      dm[i] = [i * del, fill.flatten]
    end
    for i in 1..other.length
      for j in 1..first.length
        dm[i][j] = [
          dm[i-1][j-1] + (first[i-1] == other[i-1] ? 0 : sub),
          dm[i][j-1] + ins,
          dm[i-1][j] + del
        ].min
      end
    end
    dm[other.length][first.length]
  end
end
