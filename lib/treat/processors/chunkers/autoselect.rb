class Treat::Processors::Chunkers::Autoselect

  def self.chunk(entity, options = {})

    return entity.chunk(:txt) unless entity.has?(:file)
    
    ext = entity.parent_document.file.split('.')[-1]
    
    begin
      r = Treat::Processors::
      Chunkers.const_get(cc(ext))
    rescue Treat::Exception
      return entity.chunk(:txt)
    end
    
    entity.chunk(ucc(cl(r)).intern)

  end

end
