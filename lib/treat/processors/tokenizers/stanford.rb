module Treat
  module Processors
    module Tokenizers
      class Stanford
        # Require the Ruby-Java bridge.
        silently do
          require 'rjb'
          # Load the Stanford Parser Java files.
          jar = "#{Treat.bin}/stanford_parser/stanford-parser.jar"
          unless File.readable?(jar)
            raise "Could not find stanford parser JAR file in #{jar}."+
            " You may need to set Treat.bin to a custom value."
          end
          # Load the Stanford Parser classes.
          PTBTokenizer = ::Rjb::import('edu.stanford.nlp.process.PTBTokenizer')
          CoreLabelTokenFactory = ::Rjb::import('edu.stanford.nlp.process.CoreLabelTokenFactory')
          StringReader = ::Rjb::import('java.io.StringReader')
        end
        def self.tokenize(entity, options = {})
          ptbt = PTBTokenizer.new(
            StringReader.new(entity.to_s),
            CoreLabelTokenFactory.new, '')
          while ptbt.has_next
            w = ptbt.next.word
            next if w[0] == '-' && w[-1] == '-'
            entity << Treat::Entities::Entity.from_string(w)
          end
          entity
        end
      end
    end
  end
end