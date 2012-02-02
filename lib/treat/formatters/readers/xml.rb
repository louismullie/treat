module Treat
  module Formatters
    module Readers
      class XML
        require 'stanford-core-nlp'
        require 'cgi'
        # By default, backup the XML text while cleaning.
        DefaultOptions = { clean: true, backup: false }
        @@xml_cleaner = nil
        # Read the XML document and strip it of its markup.
        # Also splits the text into sentences and tokenizes it?
        #
        # Options:
        #
        # - (Boolean) :clean => whether to strip XML markup.
        # - (Boolean) :backup => whether to backup the XML 
        #   markup while cleaning.
        def self.read(document, options = {})
          options = DefaultOptions.merge(options)
          document << Treat::Entities::Entity.from_string(File.read(document.file))
          if options[:clean]
            @@xml_cleaner ||= StanfordCoreNLP.load(:tokenize, :ssplit, :cleanxml)
            document.each do |zone|
              text = StanfordCoreNLP::Text.new(zone.to_s)
              @@xml_cleaner.annotate(text)
              sentences = []
              text.get(:sentences) do |sentence|
                sentences << Treat::Entities::Sentence.from_string(sentence.to_s)
              end
              val = sentences.join(' ')
              zone.set :xml_value, CGI.escapeHTML(text.to_s) if options[:backup]
              zone.value = val
            end
          end
          document
        end
      end
    end
  end
end