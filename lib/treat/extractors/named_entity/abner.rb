module Treat
  module Extractors
    module NamedEntity
      class Abner
        # Require the Ruby-Java bridge.
        silently do
          require 'rjb'
          Rjb::load('', ['-Xms256M', '-Xmx512M'])
          puts Rjb.import('tagger')
        end
        @@tagger = nil
        def self.named_entity(entity)
          @@tagger ||= AbnerTagger.new
          @@tagger.tokenize(entity)
        end
      end
    end
  end
end

