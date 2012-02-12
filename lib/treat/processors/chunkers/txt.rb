# This class separates a plain section file into
# zones based on an extremely naive analysis of the
# file. Suprisingly, this works pretty well.
module Treat::Processors::Chunkers::Txt
  
  # Split sections into smaller zones.
  def self.chunk(section, options = {})
    zones = section.to_s.split("\n")
    zones.each do |zone|
      zone.strip!
      next if zone == ''
      if false # fix
        section << Treat::Entities::List.new(zone)
      end
      if zone.length < 60
        section << Treat::Entities::Title.new(zone)
      else
        section << Treat::Entities::Paragraph.new(zone)
      end
    end
  end
  
end