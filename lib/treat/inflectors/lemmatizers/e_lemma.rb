module Treat
  module Inflectors
    module Lemmatizers
      class ELemma
        silently { require 'treat/inflectors/lemmatizers/elemma/elemma'}
        def self.lemma(entity, options = nil)
          ::ELemma::parse(word, entity.tag)
        end
      end
    end
  end
end