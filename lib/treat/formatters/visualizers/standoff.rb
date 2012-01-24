module Treat
  module Formatters
    module Visualizers
      # This class allows the visualization of 
      # an entity in standoff format; for example:
      # (S (NP John) (VP has (VP come))).
      class Standoff
        Recurse = Proc.new do |entity, options|
          v = ''
          entity.each { |child| v += visualize(child, options) }
          v
        end
        # Visualize the entity using standoff notation.
        # This can only be called on sentences, as it
        # is not a suitable format to represent larger
        # entity.
        def self.visualize(entity, options = {})
          options = {:indent => 0} if options.empty?
          value = '';  spaces = ''
          options[:indent].times { spaces << '   '}
          options[:indent] += 1
          if entity.is_a?(Treat::Entities::Token)
            value += "#{spaces}(#{entity.tag} #{entity.value})"
          elsif entity.is_a?(Treat::Entities::Constituent)
            value += ("#{spaces}(#{entity.tag}\n" +
            "#{Recurse.call(entity, options)})\n")
          elsif entity.is_a?(Treat::Entities::Sentence)
            value += ("#{spaces}(S\n" +
            "#{Recurse.call(entity, options)})\n")
          else
            raise 'Standoff format is unsuitable to represent' +
            ' entities larger than sentences.'
          end
          options[:indent] -= 1
          value.gsub!(")\n)", "))")
          value
        end
      end
    end
  end
end
