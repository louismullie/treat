# encoding: utf-8
# A wrapper for the Poppler pdf2text utility, which
# extracts the text from a PDF file.
class Treat::Workers::Formatters::Readers::PDF

  require 'fileutils'
  
  # Read a PDF file using the Poppler pdf2text utility.
  #
  # Options: none.
  def self.read(document, options = {})
    
    self.create_temp_file(:txt) do |tmp|
      `pdftotext #{document.file} #{tmp} `.strip
      f = File.read(tmp)
      f.gsub!("\t\r ", '')
      f.gsub!('-­‐', '-')
      f.gsub!("\n\n", '#keep#')
      f.gsub!("\n", ' ')
      # Fix for an incompatible space character.
      f.gsub!(" ", ' ')  
      f.gsub!('#keep#', "\n\n")
      
      document.value = f
      document.set :format, 'pdf'
      document
      
    end
    
  end
  
  # Create a temporary file which is deleted
  # after execution of the block.
  def self.create_temp_file(ext, value = nil, &block)
    if not FileTest.directory?(Treat.paths.tmp)
      FileUtils.mkdir(Treat.paths.tmp)
    end
    fname = Treat.paths.tmp + 
    "#{Random.rand(10000000).to_s}.#{ext}"
    File.open(fname, 'w') do |f|
      f.write(value) if value
      block.call(f.path)
    end
  ensure
    File.delete(fname)
  end

end