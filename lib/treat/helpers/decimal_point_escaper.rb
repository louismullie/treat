module Treat::Helpers
  
  class DecimalPointEscaper

    EscapeChar = '^^'
    EscapedEscapeChar = '\^\^'
    
    def self.escape!(s)
      s.gsub!(/([0-9]+)\.([0-9]+)/) do
        $1 + EscapeChar + $2
      end
    end

    def self.unescape!(s)
      s.gsub!(/([0-9]+)#{EscapedEscapeChar}([0-9]+)/) do
        $1 + '.' + $2
      end
    end

  end
  
end
