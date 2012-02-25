class Treat::Processors::Chunkers::Autoselect

  def self.chunk(entity, options = {})

    p = entity.parent_document
    
    if p && p.has?(:file)
      entity.chunk(p.format, options)
    else
      entity.chunk(:txt)
    end    

  end

end
