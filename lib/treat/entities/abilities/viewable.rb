# Gives entities the ability to be converted
# to string representations (#to_string, #to_s,
# #to_str, #inspect, #print_tree).
module Treat::Entities::Abilities::Viewable
  
  # Return the entity's true string value in 
  # plain text format. Non-terminal entities
  # will normally have an empty value.
  def to_string; @value; end
  
  # Returns the entity's string value by 
  # imploding the value of all terminal 
  # entities in the subtree of that entity.
  def to_s; visualize(:txt); end
  
  # #to_str is the same as #to_s.
  alias :to_str :to_s
  
  # Return a shortened value of the entity's 
  # string value using [...], with a cutoff
  # number of words set at ml.
  def short_value(ml = 6)
    visualize(
      :short_value, 
      :max_length => ml
    ) 
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
      s += "  |  #{short_value.inspect}" +
      "  |  #{@features.inspect}" +
      "  | { #{dependencies.join(', ')} }"
    end
    s
  end
  
  # Print out an ASCII representation of the tree.
  def print_tree; puts visualize(:tree); end
  
end