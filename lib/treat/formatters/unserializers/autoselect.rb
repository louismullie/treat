# This class doesn't perform any unserializing;
# it simply routes the document to an unserializer
# based on the file extension of the document.
class Treat::Formatters::Unserializers::Autoselect

  # Unserialize any supported file format.
  #
  # Options: none.
  def self.unserialize(document, options = {})
    ext = document.file.split('.')[-1]
    if ext == 'yaml' || ext == 'yml'
      document.unserialize(:yaml)
    elsif ext == 'xml'
      document.unserialize(:xml)
    else
      raise "File #{document.file} was not recognized "+
      "as a supported serialized format."
    end
  end

end