module Treat
  module Lexicalizers
    module Synsets
      class RitaWn
        # Require the Ruby-Java bridge.
        #silently do
          require 'rjb'
          # Load the RitaWN jars.
          Rjb::load("#{Treat.bin_path}/jwnl/jwnl.jar", [])
          JWNLException = Rjb::import('net.didion.jwnl.JWNLException')
          Rjb::load("#{Treat.bin_path}/ritaWN/library/ritaWN.jar", [])
          Rjb::add_jar("#{Treat.bin_path}/ritaWN/library/supportWN.jar")
          Rjb::add_jar("#{Treat.bin_path}/ritaWNcore1.0.jar")
          RiWordnet = ::Rjb::import('rita.wordnet.RiWordnet')
        #end
        def self.synsets(word, options = nil)

        end
      end
    end
  end
end