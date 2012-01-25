module Treat
  module Formatters
    module Readers
      class Abw
        require 'rexml/document'
        require 'rexml/streamlistener'
        def self.read(document, options = {})
          xml_h = AbiWordXmlHandler.new(
          REXML::Document.parse_stream((IO.read(document.file)), xml_h))
          document << xml_h.plain_text
          document
        end
        class AbiWordXmlHandler
          include REXML::StreamListener
          attr_reader :plain_text
          def initialize
            @plain_text = ""
          end
          def text s
            begin
              s = s.strip
              if s.length > 0
                @plain_text << s
                @plain_text << "\n"
              end
            end if s != 'AbiWord' && s != 'application/x-abiword'
          end
        end
      end
    end
  end
end