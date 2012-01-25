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
          return entity.value if !entity.has_children?
          value = ''
          entity.each do |child|
            if child.is_a?(Treat::Entities::Token) || child.value != ''
              # Remove the trailing space for tokens that
              # 'stick' to the previous one, such
              # as punctuation symbols and clitics.
              if child.is_a?(Treat::Entities::Punctuation) ||
                child.is_a?(Treat::Entities::Clitic)
                value.strip!
              end
              value += child.value + options[:sep]
            else
              value += visualize(child, options)
            end
          end
          value
        end
      end
    end
  end
end
