# Serialization of entities to XML format.
class Treat::Workers::Formatters::Serializers::XML

  # Reauire the Nokogiri XML parser.
  require 'nokogiri'
  # Serialize an entity tree in XML format.
  #
  # Options:
  # - (String) :file => a file to write to.
  def self.serialize(entity, options = {})
    options[:file] ||= (entity.id.to_s + '.xml')
    options[:indent] = 0
    enc = entity.to_s.encoding.to_s.downcase
    string = "<?xml version=\"1.0\" " +
    "encoding=\"#{enc}\" ?>\n<treat>\n"
    val = self.recurse(entity, options)
    string += "#{val}\n</treat>"
    File.open(options[:file], 'w') do |f|
      f.write(string)
    end; return options[:file]
  end
  
  def self.recurse(entity, options)
    spaces, string = '', ''
    options[:indent].times { spaces << ' ' }
    attributes = " id='#{entity.id}'"
    if !entity.features.nil? && entity.features.size != 0
      attributes << ' '
      entity.features.each_pair do |feature, value|
        if value.is_a? Treat::Entities::Entity
          attributes << "#{feature}='#{value.id}' "
        else
          value = value.inspect if value.is_a?(Symbol)
          attributes << "#{feature}='#{escape(value)}' "
        end
      end
      ############ To be refactored
      unless entity.edges.empty?
        attributes << "edges='"
        a = []
        entity.edges.each do |edge|
          a << ("{target: #{edge.target}, "+
          "type: #{edge.type}, " +
          "directed: #{edge.directed}, " +
          "direction: #{edge.direction}}" )
        end
        # Structs.
        attributes << a.join(',') + "'"
      end
      ############ End of ugly code
    end
    tag = entity.class.to_s.split('::')[-1].downcase
    string += "#{spaces}<#{tag}#{attributes}>"
    unless entity.is_a?(Treat::Entities::Token)
      string += "\n"
    end
    if entity.has_children?
      options[:indent] += 1
      entity.children.each do |child|
        string += self.recurse(child, options)
      end
      options[:indent] -= 1
    else
      string += "#{escape(entity.value)}"
    end
    unless entity.is_a?(Treat::Entities::Token)
      string += "#{spaces}"
    end
    string += "</#{tag}>\n"
  end

  def self.escape(input)
    result = input.to_s.dup
    result.gsub!("&", "&amp;")
    result.gsub!("<", "&lt;")
    result.gsub!(">", "&gt;")
    result.gsub!("'", "&apos;")
    result.gsub!("\"", "&quot;")
    result
  end

end
