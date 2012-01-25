module Treat
  module Formatters
    module Cleaners
      # This class is a wrapper for Hpricot's function
      # to strip a text of its HTML markup.
      class HTML
        # Require Hpricot.
        silence_warnings { require 'hpricot' }
        DefaultOptions = { backup: true }
        # Clean a document of its html markup using Hpricot.
        # 
        # Options:
        #
        # - :backup => (Boolean) whether to backup the HTML
        # text under :html_value.
        def self.clean(document, options = {})
          options = DefaultOptions.merge(options)
          document.each_text do |text|
            if options[:backup]
              text.set :html_value, text.value
            end
            text.value = Hpricot(text.value).inner_text
          end
          document
        end
      end
    end
  end
end
