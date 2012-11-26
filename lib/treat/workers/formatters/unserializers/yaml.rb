# Unserialization of entities stored in YAML format.
class Treat::Workers::Formatters::Unserializers::YAML

  silence_warnings do
    # Require the Psych YAML parser.
    # require 'psych'
  end
  
  # Require date to revive DateTime.
  require 'date'

  # Unserialize a YAML file.
  #
  # Options: none.
  def self.unserialize(document, options = {})
    document << ::YAML.load(
    File.read(document.file))
    document
  end

end
