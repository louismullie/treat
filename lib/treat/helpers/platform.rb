# Detect the platform we're running on.
def detect_platform
  p = RUBY_PLATFORM.downcase
  return :mac if p.include?("darwin")
  return :windows if p.include?("mswin")
  return :linux if p.include?("linux")
  return :unknown
end

if detect_platform == :windows
  NULL_DEVICE = 'NUL'
else
  NULL_DEVICE = '/dev/null'
end