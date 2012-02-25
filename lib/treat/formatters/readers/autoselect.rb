# This class delegates the reading task to
# the appropriate reader based on the file
# extension of the supplied document.
class Treat::Formatters::Readers::Autoselect
  
  # Select the appropriate reader based on 
  # the format of the filename in document.
  #
  # Options: none.
  def self.read(document, options)
    
    reader = document.format
    
    begin
      r = Treat::Formatters::Readers.
      const_get(cc(reader))
    rescue Treat::Exception => e
      
      raise Treat::Exception,
      "Cannot find a reader " +
      "for format: '#{ext}'. " +
      "(#{e.message})"
    end
    
    document = r.read(document, options)
    
  end

end
