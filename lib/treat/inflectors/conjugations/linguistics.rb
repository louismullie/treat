module Treat
  module Inflectors
    module Conjugations
      class Linguistics
        silence_warnings { require 'linguistics' }
        def self.conjugate(entity, parameters)
          begin
            l = entity.language.to_s.upcase
            delegate = nil
            silence_warnings { delegate = ::Linguistics.const_get(l) }
          rescue RuntimeError
            raise "Ruby Linguistics does not have a module " + 
            " installed for the #{entity.language} language."
          end
          if parameters[:mode] == :infinitive
            silence_warnings { delegate.infinitive(entity.to_s) }
          elsif parameters[:mode] == :participle && parameters[:tense] == :present
            silence_warnings { delegate.present_participle(entity.to_s) }
          elsif parameters[:count] == :plural && parameters.size == 1
            silence_warnings { delegate.plural_verb(entity.to_s) }
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