module Treat
  module Extractors
    module NamedEntityTag
      class Abner
        # Require the Ruby-Java bridge.
        silence_warnings do
          require 'rjb'
          Rjb::load('', ['-Xms256M', '-Xmx512M'])
          Rjb::add_jar('/ruby/bin/ritaWN/ritaWN.jar')
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

