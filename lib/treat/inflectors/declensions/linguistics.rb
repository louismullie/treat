module Treat
  module Inflectors
    module Declensions
      # This class is a wrapper for the functions included
      # in the 'linguistics' gem that allow to obtain the
      # declensions of a word.
      # 
      # Project website: http://deveiate.org/projects/Linguistics/
      class Linguistics
        require 'treat/helpers/linguistics_loader'
        # Retrieve a declension of a word using the 'linguistics' gem.
        # 
        # Options:
        #
        # - (Identifier) :count => :singular, :plural
        def self.declensions(entity, options = {})
          unless options[:count]
            raise Treat::Exception, 
            "Must supply option count (:singular or :plural)."
          end
          klass = Treat::Helpers::LinguisticsLoader.load(entity.language)
          string = entity.to_s
          if entity.category == :verb
            raise Treat::Exception,
            "Cannot retrieve the declensions of a verb. " +
            "Use #singular_verb and #plural_verb instead."
          end
          if options[:count] == :plural
            if entity.has?(:category) &&
              [:noun, :adjective, :verb].include?(entity.category)
              silence_warnings do
                klass.send(:"plural_#{entity.category}", string)
              end
            else
              silence_warnings { klass.plural(string) }
            end
          end
        end
      end
    end
  end
end
