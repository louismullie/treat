# This class allows the visualization of
# an entity in standoff format; for example:
# (S (NP John) (VP has (VP come))).
class Treat::Formatters::Visualizers::Standoff

  # Start out with an indent of 0.
  DefaultOptions = { :indent => 0 }
  
  # A lambda to recursively visualize the children
  # of an entity.
  Recurse = lambda do |entity, options|
    v = ''
    entity.each { |child| v += visualize(child, options) }
    v
  end
  
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
      value += "#{spaces}(#{entity.tag} #{entity.value})"
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
  
end