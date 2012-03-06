# This class separates a string into logical zones.
class Treat::Processors::Chunkers::TXT
  
  # Split entitys into smaller zones.
  def self.chunk(entity, options = {})
    
    entity.check_hasnt_children
    
    zones = entity.to_s.split("\n")
    zones.each do |zone|
      zone.strip!
      next if zone == ''
      entity << Treat::Entities::Zone.
      from_string(zone)
    end
    
  end
  
end