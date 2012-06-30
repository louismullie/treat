# This is ugly, we should change it.
EscapeChar = '^^'
EscapedEscapeChar = '\^\^'
 
def escape_floats!(s)
  s.gsub!(/([0-9]+)\.([0-9]+)/) do
    $1 + EscapeChar + $2
  end
end

def unescape_floats!(s)
  s.gsub!(/([0-9]+)#{EscapedEscapeChar}([0-9]+)/) do
    $1 + '.' + $2
  end
end