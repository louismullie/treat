class Treat::Processors::Chunkers::HTML

  require 'nokogiri'

  def self.chunk(entity, options = {})
    entity.check_hasnt_children
    doc = Nokogiri::HTML(entity.value)
    recurse(entity, doc)
    doc = nil
  end

  def self.recurse(node, html_node, level = 1)

    in_list = false

    html_node.children.each do |child|
      
      next if child.name == 'text'

      txt = child.inner_text
      
      if child.name == 'title'

        t = node << Treat::Entities::Title.
        from_string(txt)
        t.set :level, 0
        
      elsif child.name =~ /^h([0-9]{1})$/ ||
        (child.name == 'p' && txt.length < 60 && 
        node.parent.type == :section)
        
        if $1
          lvl = $1.to_i
          if lvl <= level
            node.ancestors_with_type(:section).
              each do |s|
                l = s.has?(:level) ? s.level : 1
                node = s if l == lvl - 1
            end
            node = node <<
            Treat::Entities::Section.new
          elsif lvl > level
            node = node <<
            Treat::Entities::Section.new
          end
          level = lvl
          node.set :level, level

        end

        t = node <<
        Treat::Entities::Title.new(txt)
        t.set :level, level

      elsif child.name == 'p'
        node << Treat::Entities::Zone.
        from_string(txt)

      elsif ['ul', 'ol'].include?(child.name)
        node = node <<
        Treat::Entities::List.new
      elsif ['li'].include?(child.name)
        n = Treat::Entities::Entity.
        zone_from_string(txt)
        node << n
      end

      if child.children.size > 0
        recurse(node, child, level)
      end

    end

  end

end
