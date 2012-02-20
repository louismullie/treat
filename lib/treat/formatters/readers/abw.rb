class Treat::Formatters::Readers::ABW
  require 'rexml/document'
  require 'rexml/streamlistener'
  def self.read(document, options = {})
    xml_h = AbiWordXmlHandler.new
    REXML::Document.parse_stream(IO.read(document.file), xml_h)
    document << Treat::Entities::Entity.from_string(xml_h.plain_text)
    document
  end
  class AbiWordXmlHandler
    include REXML::StreamListener
    attr_reader :plain_text
    def initialize
      @plain_text = ""
    end
    def text(s)
      if s != 'AbiWord' && s != 'application/x-abiword'
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