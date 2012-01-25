module Treat
  module Processors
    module Segmenters
      # A wrapper for the sentence splitter supplied by 
      # the Stanford parser.
      class Stanford
        # Require the Ruby-Java bridge.
        silence_warnings do
          require 'rjb'
          jar = "#{Treat.bin}/stanford-parser*/stanford-parser*.jar"
          jars = Dir.glob(jar)
          if jars.empty? || !File.readable?(jars[0])
            raise "Could not find stanford parser JAR file (lookin in #{jar})."+
            " You may need to manually download the JAR files and/or set Treat.bin."
          end
          ::Rjb::load(jars[0])
          DocumentPreprocessor =
          ::Rjb::import('edu.stanford.nlp.process.DocumentPreprocessor')
          StringReader = ::Rjb::import('java.io.StringReader')
        end
        # Segment sentences using the sentence splitter supplied by 
        # the Stanford parser.
        def self.segment(entity, options = {})
          sr = StringReader.new(entity.to_s)
          sit = DocumentPreprocessor.new(sr).iterator
          while sit.has_next
            str = sit.next.to_string
            str.gsub!(', ', ' ')              # Fix - find better way to implode.
            str.gsub!(' \'s', '\'s')
            str.gsub!(' .', '.')
            str.gsub!(' ,', ',')
            str.gsub!(' ;', ';')
            str.gsub!(/-[A-Z]{3}-/, '')
            str = str[1..-2]
            sentence = Entities::Entity.from_string(str)
            if options[:tokenize] == true
              tit = s.iterator
              while tit.has_next
                w = tit.next.word
                next if w[0] == '-' && w[-1] == '-'
                sentence << Entities::Entity.from_string(w)
              end
            end
            entity << sentence
          end
          entity
        end
      end
    end
  end
end
