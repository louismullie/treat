# This class simply reads a plain text file.
class Treat::Formatters::Readers::TXT

  # Build an entity from a string 
  # in plain text format.
  #
  # Options: none.
  def self.read(document, options = {})
    document.value = File.read(document.file)
    document.set :format, :txt
    document
  end
  
end