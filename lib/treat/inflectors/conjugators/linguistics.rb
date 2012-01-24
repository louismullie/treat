module Treat
  module Inflectors
    module Conjugators
      class Linguistics
        silently { require 'linguistics' }
        def self.conjugate(entity, parameters)
          begin
            l = entity.language.to_s.upcase
            delegate = nil
            silently { delegate = ::Linguistics.const_get(l) }
          rescue RuntimeError
            raise "Ruby Linguistics does not have a module " + 
            " installed for the #{entity.language} language."
          end
          if parameters[:mode] == :infinitive
            silently { delegate.infinitive(entity.to_s) }
          elsif parameters[:mode] == :participle && parameters[:tense] == :present
            silently { delegate.present_participle(entity.to_s) }
          elsif parameters[:count] == :plural && parameters.size == 1
            silently { delegate.plural_verb(entity.to_s) }
          else
            raise Treat::Exception,
            'This combination of modes, tenses, persons ' +
            'and/or counts is not presently supported.'
          end
        end
      end
    end
  end
end