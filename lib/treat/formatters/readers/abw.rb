# A wrapper for a small utility written
# by Mark Watson to read AbiWord files.
# Released under the GPL.
#
# Original project website: 
# http://www.markwatson.com/opensource/
#
# Todo: reimplement with Nokogiri and use
# XML node information to better translate
# the format of the text.
class Treat::Formatters::Readers::ABW
  
  require 'rexml/document'
  require 'rexml/streamlistener'
  
  # Extract the readable text from an AbiWord file.
  #
  # Options: none.
  def self.read(document, options = {})
    
    xml_h = ABWXmlHandler.new
    REXML::Document.parse_stream(
    IO.read(document.file), xml_h)
    document << Treat::Entities::Entity.
    from_string(xml_h.plain_text)

  end
  
  # Helper class to parse the AbiWord file.
  class ABWXmlHandler
    include REXML::StreamListener
    attr_reader :plain_text
    def initialize
      @plain_text = ""
    end
    def text(s)
      if s != 'AbiWord' && s != 
        'application/x-abiword'
        s.strip!
        if s.length > 0
          s += ' '
          s += "\n\n" if s.length < 60
        end
        @plain_text << s
      end
    end
  end
  
end