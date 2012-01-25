module Kernel
  # Require file utilities.
  require 'fileutils'
  # Returns the platform we are running on.
  def platform
    RUBY_PLATFORM.split("-")[1]
  end
  # Runs a block of code silently, i.e. without
  # expressing warnings even in verbose mode.
  # Rename to silence_streamsings.
  def silently(&block)
    warn_level = $VERBOSE
    $VERBOSE = nil
    result = block.call
    $VERBOSE = warn_level
    result
  end
  def silence_streams(*streams)
    yield
  end
  # Create a temporary file which is deleted
  # after execution of the block.
  require 'tempfile'
  def create_temp_file(ext, value = nil, &block)
    tmp = Tempfile.new(['', ".#{ext.to_s}"], Treat.tmp)
    tmp.puts(value) if value
    block.call(tmp.path)
  end
  # A list of acronyms used in class names within
  # the program. These do not CamelCase; they
  # CAMELCASE.
  @@acronyms = ['XML', 'HTML', 'YAML', 'UEA', 'LDA', 'PDF', 'GOCR', 'Treat'].join('|')
  @@cc_cache = {}
  # Convert un_camel_case to CamelCase.
  def camel_case(o_phrase)
    phrase = o_phrase.to_s.dup
    return @@cc_cache[o_phrase] if @@cc_cache[o_phrase]
    phrase.gsub!(/#{@@acronyms.downcase}[^a-z]+/) { |a| a.upcase }
    phrase.gsub!(/^[a-z]|_[a-z]/) { |a| a.upcase }
    phrase.gsub!('_', '')
    @@cc_cache[o_phrase] = phrase
    phrase
  end
  @@ucc_cache = {}
  # Convert CamelCase to un_camel_case.
  def un_camel_case(o_phrase)
    phrase = o_phrase.to_s.dup
    return @@ucc_cache[o_phrase] if @@ucc_cache[o_phrase]
    phrase.gsub!(/#{@@acronyms}/) { |a| a.downcase.capitalize }
    phrase.gsub!(/[A-Z]/) { |p| '_' + p.downcase  }
    phrase = phrase[1..-1] if phrase[0] == '_'
    @@ucc_cache[o_phrase] = phrase
    phrase
  end
  # Return the levensthein distance between two stringsm
  # taking into account the costs of insertion, deletion,
  # and substitution. Stolen from:
  # http://ruby-snippets.heroku.com/string/levenshtein-distance
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
  # Search the list to see if there are words
  # similar to name. If yes, return a string
  # saying "Did you mean ... ?"
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
  def caller_method(n = 3)
    at = caller(n).first
    /^(.+?):(\d+)(?::in `(.*)')?/ =~ at
    :"#{Regexp.last_match[3]}"
  end
  def cl(n); n.to_s.split('::')[-1]; end
  def cc(w); Kernel.camel_case(w); end
  def ucc(w); Kernel.un_camel_case(w); end
end
