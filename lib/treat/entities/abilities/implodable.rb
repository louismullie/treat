module Treat::Entities::Abilities::Implodable

  def implode
    
    return @value.dup if !has_children?

    value = ''

    each do |child|
      if child.is_a?(Treat::Entities::Section)
        value += "\n\n" 
      end
      if child.is_a?(Treat::Entities::Token) || child.value != ''
        if child.is_a?(Treat::Entities::Punctuation) ||
          child.is_a?(Treat::Entities::Clitic)
          value.strip!
        end
        value += child.value + ' '
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
