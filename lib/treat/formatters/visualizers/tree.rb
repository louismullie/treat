# This class generates an ASCII representation
# of a tree of entities.
class Treat::Formatters::Visualizers::Tree

  # Start out with an indent at 0.
  DefaultOptions = { :indent => 0 }
  
  # Obtain a plain text tree representation
  # of the entity.
  def self.visualize(entity, options = {})
    options = DefaultOptions.merge(options)
    string = ''
    if entity.has_children?
      spacer = '--'
      spaces = ''
      options[:indent].times { spaces << '   '}
      string << "+ #{entity.inspect}\n#{spaces}|"
      options[:indent] += 1
      entity.children.each do |child|
        string = string + "\n" + spaces + '+' +
        spacer + self.visualize(child, options)
      end
      options[:indent] -= 1
      return string
    end
    '> ' + entity.inspect
  end
  
end