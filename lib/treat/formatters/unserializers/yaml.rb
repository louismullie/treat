# This class is a wrapper for the Psych YAML
# parser; it unserializes YAML files.
class Treat::Formatters::Unserializers::YAML

  # Require the Psych YAML parser.
  require 'psych'
  # Require date to revive DateTime.
  require 'date'
  # Unserialize a YAML file.
  #
  # Options: none.
  def self.unserialize(document, options = {})
    document << ::Psych.load(File.read(document.file))
    document
  end

end