# Creates a plain text visualization of an entity.
class Treat::Formatters::Visualizers::TXT

  # Obtain a plain text visualization of the entity,
  # with no additional information.
  def self.visualize(entity, options = {})
    recurse(entity, options).strip
  end

  def self.recurse(entity, options)
    
    return entity.value.dup if !entity.has_children?

    value = ''

    entity.each do |child|
      value += "\n\n" if child.is_a?(Treat::Entities::Section)
      if child.is_a?(Treat::Entities::Token) || child.value != ''
        # Remove the trailing space for tokens that
        # 'stick' to the previous one, such
        # as punctuation symbols and clitics.
        if child.is_a?(Treat::Entities::Punctuation) ||
          child.is_a?(Treat::Entities::Clitic)
          value.strip!
        end
        value += child.value + ' '
      else
        value += recurse(child, options)
      end
      if child.is_a?(Treat::Entities::Title) ||
        child.is_a?(Treat::Entities::Paragraph)
        value += "\n\n"
      end
    end

    value

  end

end
