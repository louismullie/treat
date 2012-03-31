class Treat::Formatters::Unserializers::Autoselect

  def self.unserialize(document, options = {})
    file = document.file
    if file.index('yml') || file.index('yaml')
      document.unserialize(:yaml, options)
    elsif file.index('xml')
      document.unserialize(:xml, options)
    else
      raise Treat::Exception,
      "Unreadable serialized format for file #{file}."
    end
  end

end
