module Treat
  module Viewable
    # Return the entity's string value in plain text format.
    def to_string; @value; end
    # An alias for #to_string.
    def to_s; visualize(:txt); end
    alias :to_str :to_s
    # Return a shortened value of the entity's string value using [...].
    def short_value(ml = 6); visualize(:short_value, :max_length => ml); end
    # Return an informative string representation of the entity.
    def inspect
      s = "#{cl(self.class)} (#{@id.to_s})"
      if caller_method(2) == :inspect
        @id.to_s
      else
        dependencies = []
        @dependencies.each do |dependency|
          dependencies << "#{dependency.target}#{dependency.type}"
        end
        s += "  |  #{short_value.inspect}" +
        "  |  #{@features.inspect}" +
        "  | { #{dependencies.join(', ')} }"
      end
      s
    end
    # Print out an ASCII representation of the tree.
    def print_tree; puts visualize(:tree); end
  end
end
