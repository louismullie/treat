module Treat
  module Formatters
    module Readers
      # A reader for the ODT (Open Office) document format.
      #
      # Based on work by Mark Watson, licensed under the GPL.
      # Original project website: http://www.markwatson.com/opensource/
      class Odt
        # Require the 'zip' gem to unarchive the ODT files
        silence_warnings { require 'zip' }
        # Build an entity from an ODT file.
        def self.read(document, options = {})
          f = nil
          Zip::ZipFile.open(document.file, Zip::ZipFile::CREATE) do |zipfile|
            f = zipfile.read('content.xml')
          end
          raise "Couldn't unzip dot file #{document.file}!" unless f
          xml_h = OOXmlHandler.new
          REXML::Document.parse_stream(f, xml_h)
          puts xml_h.plain_text
          document << Treat::Entities::Entity.from_string(xml_h.plain_text)
          document
        end
        # Xml listener for the parsing of the ODT file.
        class OOXmlHandler
          require 'rexml/document'
          require 'rexml/streamlistener'
          include REXML::StreamListener
          attr_reader :plain_text
          def initialize
            @plain_text = ""
            @last_name = ""
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
