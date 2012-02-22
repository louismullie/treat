# A wrapper for the 'antiword' command-line utility.
class Treat::Formatters::Readers::DOC
  
  # Extract the readable text from a DOC file
  # using the antiword command-line utility.
  #
  # Options: none.
  def self.read(document, options = {})
    f = `antiword #{document.file}`
    f.gsub!("\n\n", '#keep#')
    f.gsub!("\n", ' ')
    f.gsub!('#keep#', "\n\n")
    
    document << Treat::Entities::Zone.from_string(f)
    
  end
  
end