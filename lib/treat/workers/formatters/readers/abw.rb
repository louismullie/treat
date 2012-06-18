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
class Treat::Workers::Formatters::Readers::ABW

  silence_warnings do
    require 'rexml/document'
    require 'rexml/streamlistener'
  end
  
  # Extract the readable text from an AbiWord file.
  #
  # Options: none.
  def self.read(document, options = {})

    xml_h = ABWXmlHandler.new
    REXML::Document.parse_stream(
    IO.read(document.file), xml_h)

    document.value = xml_h.plain_text
    document.set :format, :abw_word
    document

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
          s += "\n\n" if s.length < 45
        end
        @plain_text << s
      end
    end
  end

end
