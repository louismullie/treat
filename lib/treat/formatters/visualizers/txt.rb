module Treat
  module Formatters
    module Visualizers
      # Creates a plain text visualization of an entity.
      class Txt
        # The default options for the visualizer.
        DefaultOptions = { sep: ' ' }
        # Obtain a plain text visualization of the entity,
        # with no additional information.
        # 
        # Options:
        # (String) :sep => the separator to use between words.
        def self.visualize(entity, options = {})
          options = DefaultOptions.merge(options)
          return entity.value.dup if !entity.has_children?
          value = ''
          entity.each do |child|
            value += "\n\n" if child.type == :section
            if child.is_a?(Treat::Entities::Token) || child.value != ''
              # Remove the trailing space for tokens that
              # 'stick' to the previous one, such
              # as punctuation symbols and clitics.
              if [:punctuation, :clitic].include?(child.type)
                value.strip!
              end
              value += child.value + options[:sep]
            else
              value += visualize(child, options)
            end
            value += "\n\n" if [:title, :paragraph].include?(child.type)
          end
          value
        end
      end
    end
  end
end
