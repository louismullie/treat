# A reader for the ODT (Open Office)
# document format.
#
# Based on work by Mark Watson,
# licensed under the GPL.
#
# Original project website:
# http://www.markwatson.com/opensource/
#
# Todo: reimplement with Nokogiri and use
# XML node information to better translate
# the format of the text.
class Treat::Formatters::Readers::ODT

  # Require the 'zip' gem to unarchive the ODT files
  silence_warnings { require 'zip' }

  # Extract the readable text from an ODT file.
  #
  # Options: none.
  def self.read(document, options = {})
    f = nil
    Zip::ZipFile.open(document.file,
    Zip::ZipFile::CREATE) do |zipfile|
      f = zipfile.read('content.xml')
    end
    raise "Couldn't unzip dot file " +
    "#{document.file}!" unless f
    xml_h = ODTXmlHandler.new
    REXML::Document.parse_stream(f, xml_h)

    document.value = xml_h.plain_text
    document.set :format, :odt_office
    document

  end

  # Xml listener for the parsing of the ODT file.
  class ODTXmlHandler
    silence_warnings do
      require 'rexml/document'
      require 'rexml/streamlistener'
    end
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
          @plain_text << "\n\n"
        end
      end
    end
  end

end
