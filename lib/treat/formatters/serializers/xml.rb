# This class converts an entity to a storable XML format.
class Treat::Formatters::Serializers::XML

  # Reauire the Nokogiri XML parser.
  require 'nokogiri'
  # Serialize an entity tree in XML format.
  #
  # Options:
  # - (String) :file => a file to write to.
  def self.serialize(entity, options = {})
    options = options.merge({:indent => 0}) if options[:indent].nil?
    indent = options[:indent]
    if options[:indent] == 0
      enc = entity.to_s.encoding.to_s.downcase
      string = "<?xml version=\"1.0\" encoding=\"#{enc}\" standalone=\"no\" ?>\n<treat>"
    else
      string = ''
    end
    spaces = ''
    options[:indent].times { spaces << ' ' }
    attributes = " id='#{entity.id}' "
    if !entity.features.nil? && entity.features.size != 0
      attributes << ' '
      entity.features.each_pair do |feature, value|
        if value.is_a? Treat::Entities::Entity
          attributes << "#{feature}='#{value.id}' "
        else
          attributes << "#{feature}='#{escape(value)}' "
        end
      end
      attributes << "dependencies='"
      a = []
      entity.dependencies.each do |dependency|
        a << ("{target: #{dependency.target}, type: #{dependency.type}, " +
        "directed: #{dependency.directed}, " +
        "direction: #{dependency.direction}}" )
      end
      # Structs.
      attributes << a.join('--') + "'"
    end
    tag = entity.class.to_s.split('::')[-1].downcase
    unless entity.is_a?(Treat::Entities::Token)
      string += "\n"
    end
    string += "#{spaces}<#{tag}#{attributes}>"
    if entity.has_children?
      options[:indent] += 1
      entity.children.each do |child|
        string =
        string +
        serialize(child, options)
      end
      options[:indent] -= 1
    else
      string = string + "#{escape(entity.value)}"
    end
    unless entity.is_a?(Treat::Entities::Token)
      string += "\n#{spaces}"
    end
    string += "</#{tag}>\n"
    if indent == 0
      string += "\n</treat>"
      if options[:file]
        File.open(options[:file], 'w') do |f| 
          f.write(string)
        end
      end
      # puts string
    end
    string
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