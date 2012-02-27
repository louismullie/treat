# This class serializes entities in YAML format.
class Treat::Formatters::Serializers::YAML
  
  silence_warnings do
    # Require the Psych YAML serializer.
    require 'psych'
  end
  
  # Serialize an entity in YAML format.
  #
  # Options:
  # - (String) :file => a file to write to.
  def self.serialize(entity, options = {})
    yaml = ::Psych.dump(entity)
    if options[:file]
      File.open(options[:file], 'w') { |f| f.write(yaml) }
    end
    yaml
  end

end
