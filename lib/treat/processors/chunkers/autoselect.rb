class Treat::Processors::Chunkers::Autoselect

  def self.chunk(entity, options = {})
  
    unless entity.has?(:format)
      raise Treat::Exception,
      "The document must be read "+
      "before it can be chunked."
    end 
    begin
      k = Treat::Processors::
      Chunkers.const_get(cc(entity.format))
      k.chunk(entity, options)
    rescue Treat::Exception
      Treat::Processors::
      Chunkers::TXT.chunk(entity, options)
    end
    
  end

end
