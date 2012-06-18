class Treat::Workers::Formatters::Readers::Autoselect
  
  ExtensionRegexp = /^.*?\.([a-zA-Z0-9]{2,5})$/
  ImageExtensions = ['gif', 'jpg', 'jpeg', 'png']
  DefaultOptions = {
    :default_to => :txt
  }
  
  # Choose a reader to use.
  #
  # Options:
  #  - (Symbol) :default_to => format to default to.
  def self.read(document, options = {})
    options = DefaultOptions.merge(options)
    document.read(detect_format(document.file, options[:default_to]))
  end
  
  def self.detect_format(filename, default_to = nil)
    
    default_to ||= DefaultOptions[:default_to]
    ext = filename.scan(ExtensionRegexp)
    ext = (ext.is_a?(Array) && ext[0] && ext[0][0]) ? ext[0][0] : ''
    
    format = ImageExtensions.include?(ext) ? 'image' : ext
    format = 'html' if format == 'htm'
    format = 'yaml' if format == 'yml'

    format = default_to if format.to_s == ''
    
    begin
      Treat::Workers::Formatters::Readers.const_get(cc(format))
    rescue Treat::Exception
      format = default_to
    end
    
    format.intern

  end


end
