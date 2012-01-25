module Treat
  module Processors
    module Tokenizers
      # A wrapper for the Stanford parser's Penn-Treebank
      # style tokenizer.
      class Stanford
        # Require the Ruby-Java bridge.
        silence_warnings do
          require 'rjb'
          # Load the Stanford Parser Java files.
          jar = "#{Treat.bin}/stanford-parser/stanford-parser.jar"
          jars = Dir.glob(jar)
          if jars.empty? || !File.readable?(jars[0])
            raise "Could not find stanford parser JAR file (looking in #{jar})."+
            " You may need to manually download the JAR files and/or set Treat.bin."
          end
          ::Rjb::load(jars[0])
          # Load the Stanford Parser classes.
          PTBTokenizer = ::Rjb::import('edu.stanford.nlp.process.PTBTokenizer')
          CoreLabelTokenFactory = ::Rjb::import('edu.stanford.nlp.process.CoreLabelTokenFactory')
          StringReader = ::Rjb::import('java.io.StringReader')
        end
        # Tokenize the entity using a Penn-Treebank style tokenizer
        # included with the Stanford Parser.
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