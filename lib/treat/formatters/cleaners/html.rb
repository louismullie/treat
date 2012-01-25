module Treat
  module Formatters
    module Cleaners
      class HTML
        silence_warnings { require 'hpricot' }
        def self.clean(document, options = {})
          document.each_text do |text|
            text.set :html_value, text.value
            v = Hpricot(text.value).inner_text
            text.value = v
          end
          document
        end
      end
    end
  end
end
