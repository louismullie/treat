module Treat
  module Formatters
    module Readers
      class Odt
        # Build an entity from a string in plain text format.
        def self.read(document, options = {})
          f = File.read(document.file)
          f = f.force_encoding("UTF-8")
          xml_h = OOXmlHandler.new(
            REXML::Document.parse_stream(f, xml_h)
          )
          document << xml_h.plain_text
          document
        end

        class OOXmlHandler
          require 'rexml/document'
          require 'rexml/streamlistener'
          include REXML::StreamListener
          attr_reader :plain_text
          def initialize
            @plain_text = ""
          end
          def tag_start(name, attrs)
            @last_name = name
          end
          def text(s)
            if @last_name.index('text')
              s = s.strip
              if s.length > 0
                @plain_text << s
                @plain_text << "\n"
              end
            end
          end
        end
      end
      
    end
  end
end
