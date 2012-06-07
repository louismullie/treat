class Treat::Processors::Chunkers::TXT
  
  # Separates a string into
  # zones on the basis of newlines.
  #
  # Options: none.
  def self.chunk(entity, options = {})
    
    entity.check_hasnt_children
    zones = entity.to_s.split("\n")
    current = entity
    zones.each do |zone|
      zone.strip!
      next if zone == ''
      c = Treat::Entities::
      Zone.from_string(zone)
      if c.type == :title
        if current.type == :section
          current = current.parent
          current = entity << Treat::
          Entities::Section.new
        else
          current = entity << Treat::
          Entities::Section.new
        end
      end
      current << c
    end
    
  end
  
end