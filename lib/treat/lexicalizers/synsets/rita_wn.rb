module Treat
  module Lexicalizers
    module Synsets
      # Currently not implemented.
      # http://code.google.com/p/processing/downloads/list
      class RitaWn
        # Require the Ruby-Java bridge.
        #silence_warnings do
          require 'rjb'
          # Load the RitaWN jars.
          Treat.bin = '/ruby/bin'
          Rjb::load("#{Treat.bin}/ritaWN/library/jwnl.jar", [])
          Rjb::add_jar("#{Treat.bin}/ritaWN/tools.jar")
          Rjb::add_jar("#{Treat.bin}/ritaWN/library/ritaWN.jar")
          Rjb::add_jar("#{Treat.bin}/ritaWN/library/supportWN.jar")
          
          RiWordnet = ::Rjb::import('rita.wordnet.RiWordnet')
        #end
        def self.synsets(word, options = nil)

        end
      end
    end
  end
end