module Treat
  module Inflectors
    module Conjugations
      # This class is a wrapper for the functions included
      # in the 'linguistics' gem that allow to conjugate verbs.
      #
      # Project website: http://deveiate.org/projects/Linguistics/
      class Linguistics
        silence_warnings { require 'linguistics' }
        # Conjugate a verb using ruby linguistics with the specified
        # mode, tense, count and person.
        #
        # Options:
        #
        # - (Symbol) :mode => :infinitive, :indicative, :subjunctive, :participle
        # - (Symbol) :tense => :past, :present, :future
        # - (Symbol) :count => :singular, :plural
        # - (Symbol) :person => :first, :second, :third
        def self.conjugations(entity, parameters)
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
