silence_warnings { require 'english' }

module Treat
   module Inflectors
      module Declensions
         module En
            def self.declense(entity, options)
               string = entity.to_s
               if options[:count] == :plural
                 ::English.plural(string)
               elsif options[:count] == :singular
                 ::English.singular(string)
               end
            end
         end
      end
   end
end
