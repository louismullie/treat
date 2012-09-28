class Treat::Workers::Formatters::Readers::XML

  Treat::Loaders::Stanford.load
  require 'cgi'

  # By default, don't backup the XML
  # document while cleaning it.
  DefaultOptions = {
    :keep_html => false
  }

  # Hold one instance of the XML cleaner.
  @@xml_reader = nil

  # Read the XML document and strip it of its markup.
  # Also segments and tokenizes the text.
  #
  # Options:
  #
  # - (Boolean) :keep_xml => whether to backup the XML
  #   markup while cleaning.
  def self.read(document, options = {})

    raise 'Not implemented.'

    options = DefaultOptions.merge(options)

    xml = File.read(document.file)

    @@xml_reader ||= StanfordCoreNLP.load(
    :tokenize, :ssplit, :cleanxml)

    text = StanfordCoreNLP::Text.new(xml)
    @@xml_reader.annotate(text)

    text.get(:sentences).each do |sentence|

      s = Treat::Entities::Sentence.
      from_string(sentence.to_s, true)

      sentence.get(:tokens).each do |token|
        val = token.value.to_s.strip.gsub('\/', '/')
        next if val =~ /^<[^>]+>$/

        t = Treat::Entities::Token.
        from_string(val)
        c = token.get(:xml_context)

        if c
          context = []
          c.each { |tag| context << tag.to_s }
          t.set :xml_context, context
        end

        s << t

      end

      if Treat::Entities::Zone.from_string('')
        section << s
      end

      if options[:backup]
        document.set :xml_value,
        CGI.escapeHTML(text.to_s)
      end

      document.value = ''

    end
    
    document.set :format, 'xml'
    document
    
  end

end
