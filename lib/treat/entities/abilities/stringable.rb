# Gives entities the ability to be converted
# to string representations (#to_string, #to_s,
# #to_str, #inspect, #print_tree).
module Treat::Entities::Abilities::Stringable

  # Return the entity's true string value in
  # plain text format. Non-terminal entities
  # will normally have an empty value.
  def to_string; @value; end

  # Returns the entity's string value by
  # imploding the value of all terminal
  # entities in the subtree of that entity.
  def to_s; @value != '' ? @value : implode; end

  # #to_str is the same as #to_s.
  alias :to_str :to_s

  # Return a shortened value of the entity's
  # string value using [...], with a cutoff
  # number of words or length.
  def short_value(max_words = 6, max_length = 30)
    s = to_s
    words = s.split(' ')
    if s.count(' ') < (max_words - 1) ||
      s.length < max_length
        s
    else
      words[0..2].join(' ') + ' [...] ' + 
      words[-3..-1].join(' ')
    end
  end

  # Return an informative string representation
  # of the entity.
  def inspect
    s = "#{cl(self.class)} (#{@id.to_s})"
    if caller_method(2) == :inspect
      @id.to_s
    else
      dependencies = []
      @dependencies.each do |dependency|
        dependencies <<
        "#{dependency.target}#{dependency.type}"
      end
      s += "  --- #{short_value.inspect}" +
      "  ---  #{@features.inspect} " +
      "  --- #{dependencies.inspect} "
    end
    s
  end

  # Print out an ASCII representation of the tree.
  def print_tree; puts visualize(:tree); end

end
