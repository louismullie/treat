module Treat
  module Processors
    module Chunkers
      # This class separates a plain text file into 
      # zones based on an extremely naive analysis of the 
      # file. Suprisingly, this works pretty well.
      class Txt
        # Split a document into Zone objects.
        def self.chunk(text, options = {})
          zones = text.to_s.split("\n")
          zones.each do |zone|
            zone.strip!
            next if zone == ''
            if false # fix
              text << Treat::Entities::List.new(zone)
            end
            if zone.length < 60
              text << Treat::Entities::Title.new(zone)
            else
              text << Treat::Entities::Paragraph.new(zone)
            end
          end
        end
      end
    end
  end
end