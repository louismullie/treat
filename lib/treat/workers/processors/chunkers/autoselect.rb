class Treat::Workers::Processors::Chunkers::Autoselect

  def self.chunk(entity, options = {})
    entity.check_has(:format)
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
