class Treat::Processors::Chunkers::HTML

  require 'nokogiri'

  def self.chunk(entity, options = {})
    entity.check_hasnt_children
    doc = Nokogiri::HTML(entity.value)
    recurse(entity, doc, options)
  end

  def self.recurse(node, html_node, options = {})

    html_node.children.each do |child|
      txt = child.inner_text
      if child.name =~ /^h([0-9]{1})$/
        new_node = node <<
        Treat::Entities::Title.new(txt)
      elsif child.name == 'p'
        Treat::Entities::Zone.from_string(txt)
      elsif child.name == 'ul'
        new_node = node <<
        Treat::Entities::List.new(txt)
      else
        new_node = node
      end

      if child.children.size > 0
        recurse(new_node, child, options)
      end

    end

  end

end
