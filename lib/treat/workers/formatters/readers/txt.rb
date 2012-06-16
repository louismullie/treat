# This class simply reads a plain text file.
class Treat::Workers::Formatters::Readers::TXT

  # Build an entity from a string 
  # in plain text format.
  #
  # Options: none.
  def self.read(document, options = {})
    puts document.inspect
    document.value = File.read(document.file)
    document.set :format, :txt
    document
  end
  
end