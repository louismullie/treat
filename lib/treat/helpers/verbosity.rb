# Runs a block of code without warnings.
def silence_warnings(&block)
  warn_level = $VERBOSE
  $VERBOSE = nil
  result = block.call
  $VERBOSE = warn_level
  result
end

# Runs a block of code while blocking stdout.
def silence_stdout(log = '/dev/null')
  unless Treat.core.verbosity.silence]
    yield; return
  end
  old = $stdout.dup
  $stdout.reopen(File.new(log, 'w'))
  yield
  $stdout = old
end
