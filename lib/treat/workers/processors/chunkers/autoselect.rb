class Treat::Workers::Processors::Chunkers::Autoselect

  def self.chunk(entity, options = {})
    unless entity.has?(:format)
      raise Treat::Exception,
      "Must have a format to autoselect chunker."
    end
    begin
      k = Treat::Workers::Processors::
      Chunkers.const_get(cc(entity.format))
      k.chunk(entity, options)
    rescue Treat::Exception
      Treat::Workers::Processors::
      Chunkers::TXT.chunk(entity, options)
    end
    
  end

end
