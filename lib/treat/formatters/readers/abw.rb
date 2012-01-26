module Treat
  module Formatters
    module Readers
      class Abw
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
              @plain_text << s if s.strip.length > 0
            end
          end
        end
      end
    end
  end
end