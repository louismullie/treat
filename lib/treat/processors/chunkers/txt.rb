module Treat
  module Processors
    module Chunkers
      # This class separates a plain text file into 
      # zones based on a very naive analysis of the 
      # file.
      class Txt
        # Return an array of Zone objects found in the text.
        def self.chunk(text, options = {})
          zones = text.to_s.split("\n")
          zones.each do |zone|
            next if zone.strip == ''
            if false # fix
              text << Entities::List.new(zone)
            end
            if zone.length < 60
              text << Entities::Title.new(zone)
            else
              text << Entities::Paragraph.new(zone)
            end
          end
          text
        end
      end
    end
  end
end