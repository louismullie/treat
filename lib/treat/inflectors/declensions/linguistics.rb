module Treat
  module Inflectors
    module Declensions
      # This class is a wrapper for the functions included
      # in the 'linguistics' gem that allow to obtain the
      # declensions of a word.
      # 
      # Project website: http://deveiate.org/projects/Linguistics/
      class Linguistics
        # Require Ruby Linguistics
        silence_warnings { require 'linguistics' }
        # Retrieve a declension of a word using the 'linguistics' gem.
        # 
        # Options:
        #
        # - (Identifier) :count => :singular, :plural
        def self.declense(entity, options = {})
          begin
            l = entity.language.to_s.upcase
            delegate = nil
            silence_warnings { delegate = ::Linguistics.const_get(l) }
          rescue RuntimeError
            raise "Ruby Linguistics does not have a module " +
            " installed for the #{entity.language} language."
          end
          string = entity.to_s
          if options[:count] == :plural
            if entity.has?(:category) &&
              [:noun, :adjective, :verb].include?(entity.category)
              silence_warnings do
                delegate.send(:"plural_#{entity.category}", string)
              end
            else
              silence_warnings { delegate.plural(string) }
            end
          end
        end
      end
    end
  end
end
