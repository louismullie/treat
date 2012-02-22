# This class delegates the reading task to
# the appropriate reader based on the file
# extension of the supplied document.
class Treat::Formatters::Readers::Autoselect
  
  # A list of image extensions that should 
  # be routed to OCR.
  ImageExtensions = 
    ['gif', 'jpg', 'jpeg', 'png']
  
  # Select the appropriate reader based on 
  # the format of the filename in document.
  #
  # Options: none.
  def self.read(document, options)
    
    ext = document.file.split('.')[-1]
    reader = 
      ImageExtensions.include?(ext) ? 
      'image' : ext
    reader = 'html' if reader == 'htm'
    reader = 'yaml' if reader == 'yml'
    
    begin
      r = Treat::Formatters::Readers.
      const_get(cc(reader))
    rescue NameError
      raise Treat::Exception,
      "Cannot find a reader " +
      "for format: '#{ext}'."
    end
    
    document = r.read(document, options)
    
  end

end
