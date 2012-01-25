module Treat
  module Formatters
    module Visualizers
      # Handles the call to inspect.
      class Inspect
        # Return a terminal-friendly visualization of an entity.
        # 
        # Options: none.
        def self.visualize(entity, options = {})
          s = "#{entity.class.to_s.split('::')[-1]} (#{entity.id.to_s})"
          unless caller_method == :inspect
            s += "  | #{entity.short_value.inspect}  |  #{entity.features.inspect}" +
            "  | #{entity.edges.inspect}"
          end
          s
        end
      end
    end
  end
end
