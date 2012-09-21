# Visualization of entities in standoff (tag-bracketed)
# format, based on the Stanford tag-bracketed format.
class Treat::Workers::Formatters::Visualizers::Standoff

  # Start out with an indent of 0.
  DefaultOptions = { :indent => 0 }
  
  # A lambda to recursively visualize the children
  # of an entity.
  Recurse = lambda do |entity, options|
    v = ''
    entity.each { |child| v += visualize(child, options) }
    v
  end
  
  # Fix - brackets
  # Visualize the entity using standoff notation.
  # This can only be called on sentences and smaller
  # entities, as it is not a suitable format to
  # represent larger entities.
  def self.visualize(entity, options = {})
    options = DefaultOptions.merge(options)
    value = '';  spaces = ''
    options[:indent].times { spaces << '   '}
    options[:indent] += 1
    if entity.is_a?(Treat::Entities::Token)
      val = ptb_escape(entity.value)
      value += "#{spaces}(#{entity.tag} #{val})"
    elsif entity.is_a?(Treat::Entities::Phrase)
      tag = entity.has?(:tag) ? entity.tag : ''
      value += ("#{spaces}(#{tag}\n" +
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
  
  def self.ptb_escape(val)
    Treat.tags.ptb.escape_characters.each do |char, esc|
      val.gsub!(char, val)
    end
    
    val
  end
end