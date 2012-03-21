# Extends the core Kernel module to provide
# easy access to utility functions used across
# the library.
module Kernel
  
  # Require file utilities for creating and
  # deleting temporary files.
  require 'fileutils'

  # A list of acronyms used in class names within
  # the program. These do not CamelCase; they
  # CAMELCase.
  Acronyms = %w[xml html txt odt abw doc yaml uea lda pdf ptb dot ai id3 svo]

  # A cache to optimize camel casing.
  @@cc_cache = {}

  # A cache to optimize un camel casing.
  @@ucc_cache = {}

  # Runs a block of code without warnings.
  def silence_warnings(&block)
    warn_level = $VERBOSE
    $VERBOSE = nil
    result = block.call
    $VERBOSE = warn_level
    result
  end

  # Runs a block of code while blocking stdout.
  def silence_stdout(log = NULL_DEVICE)
    unless Treat.silence
      yield; return
    end
    old = $stdout.dup
    $stdout.reopen(File.new(log, 'w'))
    yield
    $stdout = old
  end
  
  # Create a temporary file which is deleted
  # after execution of the block.
  def create_temp_file(ext, value = nil, &block)
    fname = "#{Treat.lib}/../tmp/"+
    "#{Random.rand(10000000).to_s}.#{ext}"
    File.open(fname, 'w') do |f|
      f.write(value) if value
      block.call(f.path)
    end
  ensure
    File.delete(fname)
  end

  # Create a temporary directory, which is
  # deleted after execution of the block.
  def create_temp_dir(&block)
    dname = "#{Treat.lib}/../tmp/"+
    "#{Random.rand(10000000).to_s}"
    Dir.mkdir(dname)
    block.call(dname)
  ensure
    FileUtils.rm_rf(dname)
  end

  # Convert un_camel_case to CamelCase.
  def camel_case(o_phrase)
    phrase = o_phrase.to_s.dup
    return @@cc_cache[o_phrase] if @@cc_cache[o_phrase]

    if Acronyms.include?(phrase)
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
    if Acronyms.include?(phrase.downcase)
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

  # Search the list to see if there are words similar to #name
  # in the #list If yes, return a string saying "Did you mean
  # ... ?" with the names.
  def did_you_mean?(list, name)
    return '' # Fix
    list = list.map { |e| e.to_s }
    name = name.to_s
    sugg = []
    list.each do |element|
      l = levenshtein(element,name)
      if  l > 0 && l < 2
        sugg << element
      end
    end
    unless sugg.size == 0
      if sugg.size == 1
        msg += " Perhaps you meant '#{sugg[0]}' ?"
      else
        sugg_quote = sugg[0..-2].map do
          |x| '\'' + x + '\''
        end
        msg += " Perhaps you meant " +
        "#{sugg_quote.join(', ')}," +
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
    Regexp.last_match[3].gsub('block in ', '').intern
  end

  alias :cm :caller_method

  # Detect the platform we're running on.
  def detect_platform
    p = RUBY_PLATFORM.downcase
    return :mac if p.include?("darwin")
    return :windows if p.include?("mswin")
    return :linux if p.include?("linux")
    return :unknown
  end

  # Return the levensthein distance between two stringsm
  # taking into account the costs of insertion, deletion,
  # and substitution. Stolen from:
  # http://ruby-snippets.heroku.com/string/levenshtein-distance
  # Used by did_you_mean?
  def levenshtein(first, other, ins=1, del=1, sub=1)
    return nil if first.nil? || other.nil?
    dm = []
    dm[0] = (0..first.length).collect { |i| i * ins}
    fill = [0] * (first.length - 1).abs
    for i in 1..other.length
      dm[i] = [i * del, fill.flatten]
    end
    for i in 1..other.length
      for j in 1..first.length
        dm[i][j] = [
          dm[i-1][j-1] +
          (first[i-1] ==
          other[i-1] ? 0 : sub),
          dm[i][j-1] + ins,
          dm[i-1][j] + del
        ].min
      end
    end
    dm[other.length][first.length]
  end

  if detect_platform == :windows
    NULL_DEVICE = 'NUL'
  else
    NULL_DEVICE = '/dev/null'
  end
  
  def debug(msg)
    puts msg if Treat.debug
  end
  
  def prompt(msg, valid_answers)
    
    msg = msg
    n = msg.include?("\n") ? ":\n" : ''
    q = msg.include?("\n") ? '' : '?'
    
    s = "\nPlease enter one of #{valid_answers.join(', ')}: "
    puts "Do you want to #{n}#{msg}#{q} \n#{s}"
    
    begin
      answer = STDIN.gets.strip
      unless valid_answers.include?(answer)
        puts "Invalid input."
        puts s
        raise Treat::InvalidInputException
      end
      answer
    rescue Treat::InvalidInputException
      retry
    end
    
  end

end
