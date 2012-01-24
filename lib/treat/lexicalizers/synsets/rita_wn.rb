module Treat
  module Lexicalizers
    module Synsets
      # Currently not implemented.
      class RitaWn
        # Require the Ruby-Java bridge.
        #silently do
          require 'rjb'
          # Load the RitaWN jars.
          Rjb::load("#{Treat.bin}/jwnl/jwnl.jar", [])
          JWNLException = Rjb::import('net.didion.jwnl.JWNLException')
          Rjb::load("#{Treat.bin}/ritaWN/library/ritaWN.jar", [])
          Rjb::add_jar("#{Treat.bin}/ritaWN/library/supportWN.jar")
          Rjb::add_jar("#{Treat.bin}/ritaWNcore1.0.jar")
          RiWordnet = ::Rjb::import('rita.wordnet.RiWordnet')
        #end
        def self.synsets(word, options = nil)

        end
      end
    end
  end
end