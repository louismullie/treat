# This class simply reads a plain text file.
class Treat::Formatters::Readers::TXT

  # Build an entity from a string in plain text format.
  #
  # Options: none.
  def self.read(document, options = {})
    f = File.read(document.file)
    document << Treat::Entities::Zone.from_string(f)
    document
  end
  
end