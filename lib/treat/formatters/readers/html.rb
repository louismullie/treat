module Treat
  module Formatters
    module Readers
      # A temporary HTML reader; simply strips the
      # document of all of its markup.
      class HTML
        # Require Hpricot.
        silence_warnings { require 'hpricot' }
        # By default, backup the HTML text while cleaning.
        DefaultOptions = { :clean => true, :backup => false }
        # Read the HTML document and strip it of its markup.
        #
        # Options:
        #
        # - (Boolean) :clean => whether to strip HTML markup.
        # - (Boolean) :backup => whether to backup the HTML 
        #   markup while cleaning.
        def self.read(document, options = {})
          options = DefaultOptions.merge(options)
          f = File.read(document.file)
          document << Treat::Entities::Entity.from_string(f)
          if options[:clean]
            document.each do |section|
              section.set :html_value, section.value if options[:backup]
              section.value = Hpricot(section.value).inner_text
            end
          end
          document
        end
      end
    end
  end
end
