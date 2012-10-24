# Gives entities the ability to be converted
# to string representations (#to_string, #to_s,
# #to_str, #inspect, #print_tree).
module Treat::Entities::Entity::Stringable
  
  # Returns the entity's true string value.
  def to_string;  @value.dup; end
  
  # Returns an array of the childrens' string
  # values, found by calling #to_s on them.
  def to_a; @children.map { |c| c.to_s }; end
  
  alias :to_ary :to_a
  
  # Returns the entity's string value by
  # imploding the value of all terminal
  # entities in the subtree of that entity.
  def to_s
    has_children? ? implode.strip : @value.dup
  end
  
  # #to_str is the same as #to_s.
  alias :to_str :to_s

  # Return a shortened value of the entity's
  # string value using [...], with a cutoff
  # number of words or length.
  def short_value(max_length = 30)
    s = to_s
    words = s.split(' ')
    return s if (s.length < max_length) ||
    !(words[0..2] && words[-2..-1])
    words[0..2].join(' ') + ' [...] ' +
    words[-2..-1].join(' ')
  end

  # Print out an ASCII representation of the tree.
  def print_tree; puts visualize(:tree); end
  
  # Return an informative string representation
   # of the entity.
   def inspect
     name = self.class.mn
     s = "#{name} (#{@id.to_s})"
     if caller_method(2) == :inspect
       @id.to_s
     else
       edges = []
       @edges.each do |edge|
         edges <<
         "#{edge.target}#{edge.type}"
       end
       s += "  --- #{short_value.inspect}" +
       "  ---  #{@features.inspect} " +
       "  --- #{edges.inspect} "
     end
     s
   end
   
  # Helper method to implode the string value of the subtree.
  def implode
    
    return @value.dup if !has_children?
    
    value = ''

    each do |child|
      
      if child.is_a?(Treat::Entities::Section)
        value += "\n\n"
      end
      
      if child.is_a?(Treat::Entities::Token) || child.value != ''
        if child.is_a?(Treat::Entities::Punctuation) ||
          child.is_a?(Treat::Entities::Enclitic)
          value.strip!
        end
        value += child.to_s + ' '
      else
        value += child.implode
      end
      
      if child.is_a?(Treat::Entities::Title) ||
        child.is_a?(Treat::Entities::Paragraph)
        value += "\n\n"
      end
      
    end

    value

  end

end
