class Treat::Workers::Formatters::Visualizers::DOT

  require 'date'
  DefaultOptions = {
    :colors => {},
    :features => :all,
    :file => nil,
    :remove_types => [],
    :remove_features => [],
    :colors => nil,
    :first => true # For internal purposes only.
  }
  # Create the top-most graph structure
  # and delegate the creation of the graph
  # nodes to to_dot.
  def self.visualize(entity, options = {})
    options = DefaultOptions.merge(options)
    string = "graph {"
    string << self.to_dot(entity, options)
    string << "\n}"
    if options[:file]
      File.open(options[:file], 'w') { |f| f.write(string) }
    end
    string
  end
  # dot -Tpdf test4.dot > test4.pdf
  def self.to_dot(entity, options)
    # Filter out specified types.
    match_types = lambda do |t1, t2s|
      f = false
      t2s.each { |t2| f = true if Treat::Entities.match_types[t1][t2] }
      f
    end
    return '' if match_types.call(entity.type, options[:remove_types])
    # Id
    string = ''
    label = ''
    sv = entity.short_value.inspect[1..-2]
    string = "\n#{entity.id} ["
    label = "#{entity.type.to_s.capitalize}\\n\\\"#{sv}\\\""
    label.gsub!(' [...]', " [...] \\n")
    # Features
    if entity.has_features?
      unless options[:features] == :none
        label << "\\n"
        entity.features.each do |feature, value|
          next if options[:remove_features].include?(feature)
          if options[:features] == :all ||
            options[:features].include?(feature)
            if value.is_a?(Treat::Entities::Entity)
              label << "\\n#{feature}:  \\\"*#{value.id}\\\""
            elsif value.is_a?(Struct)
              label << "\\n#{feature}: \\n\{ "
              value.members.each do |member|
                v = value.send(member)
                v = v.to_s if v.is_a?(DateTime)
                v = "*#{v.id}" if v.is_a?(Treat::Entities::Entity)
                v = v ? v.inspect : ' -- '
                v = escape(v)
                label <<  "#{member}: #{v},\\n"
              end
              label = label[0..-4] unless label[-2] == '{'
              label << "\},"
            elsif value.is_a?(Hash)
              label << "\\n#{feature}: \\n\{ "
              value.each do |k,v|
                v = v ? v.inspect : ' -- '
                v = escape(v)
                label <<  "#{k}: #{v},\\n"
              end
              label = label[0..-4] unless label[-2] == '{'
              label << "\},"
            elsif value.is_a?(Array)
              label << "\\n#{feature}: \\n\[ "
              value.each do |e|
                if e.is_a?(Treat::Entities::Entity)
                  v = escape("*#{e.id}")
                else
                  v = escape(e.inspect)
                end
                label << "#{v},\\n"
              end
              label = label[0..-4] unless label[-2] == '['
              label << " \]"
            else
              label << "\\n#{feature}:  \\\"#{value}\\\""
            end
          end
        end
      end
    end
    color = nil
    if options[:colors]
      options[:colors].each do |col, lambda|
        color = col.to_s if lambda.call(entity)
        break if color
      end
    end
    label = label[0..-2] if label[-1] == ','
    string << "label=\"#{label}\",color=\"#{color.to_s}\"]"
    string.gsub!('\\\\""]', '\\""]')
    string.gsub('\"\""]', '\""]')
    # Parent-child relationships.
    if entity.has_parent?
      unless options[:first] == true
        string << "\n#{entity.parent.id} -- #{entity.id};"
      end
    end
    # Dependencies.
    if entity.has_dependencies?
      entity.dependencies.each do |dependency|
        dir = ''
        if dependency.directed == true
          dir = dependency.direction == 1 ? 'forward' : 'back'
          dir = ",dir=#{dir}"
        else
          dir = ",dir=both"
        end
        string << "\n#{entity.id} -- #{dependency.target}"
        string << "[label=#{dependency.type}#{dir}]"
      end
    end
    # Recurse.
    options[:first] = false
    if entity.has_children?
      entity.each do |child|
        string << self.to_dot(child, options)
      end
    end
    string
  end

  def self.escape(v)
    v.gsub('[', '\[')
    .gsub('{', '\}')
    .gsub(']', '\]')
    .gsub('}', '\}')
    .gsub('"', '\"')
  end
  
end
