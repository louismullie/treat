# Serialization of entities to YAML format.
class Treat::Workers::Formatters::Serializers::YAML
  
  silence_warnings do
    # Require the Psych YAML serializer.
    require 'yaml'
  end
  
  # Serialize an entity in YAML format.
  #
  # Options:
  # - (String) :file => a file to write to.
  def self.serialize(entity, options = {})
    yaml = ::YAML.dump(entity)
    options[:file] ||= (entity.id.to_s + '.yml')
    if options[:file]
      File.open(options[:file], 'w') do |f| 
        f.write(yaml)
      end
    end
    options[:file]
  end

end
