# This class separates a string into logical zones
# zones based on an extremely naive analysis of the
# file. Suprisingly, this works pretty well.
module Treat::Processors::Chunkers::Txt
  
  # Split entitys into smaller zones.
  def self.chunk(entity, options = {})
    
    Treat::Processors.warn_if_has_children(entity)
    
    zones = entity.to_s.split("\n")
    zones.each do |zone|
      zone.strip!
      next if zone == ''
      if false # fix
        entity << Treat::Entities::List.new(zone)
      end
      if zone.length < 60
        entity << Treat::Entities::Title.new(zone)
      else
        entity << Treat::Entities::Paragraph.new(zone)
      end
    end
  end
  
end