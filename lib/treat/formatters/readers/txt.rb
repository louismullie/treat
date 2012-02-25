# This class simply reads a plain text file.
class Treat::Formatters::Readers::TXT

  # Build an entity from a string 
  # in plain text format.
  #
  # Options: none.
  def self.read(document, options = {})
    d = document << Treat::Entities::Zone.
    from_string(File.read(document.file))
    d.set :format, :txt
  end
  
end