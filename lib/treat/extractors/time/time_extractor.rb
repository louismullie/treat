module Treat
  module Extractors
    module Time
      class TimeExtractor
        def self.clean_tree(entity)
          entity.features.delete(:time_link)
          entity.each_phrase { |phrase| phrase.set :time_link, true }
          ancestor = entity.parent
          while !ancestor.nil?
            if ancestor.has?(:time_link)
              ancestor.features.delete(:start_time)
              ancestor.features.delete(:end_time)
              ancestor.features.delete(:time_recurrence)
              ancestor.features.delete(:time_recurrence_interval)
              ancestor.features.delete(:message)
              ancestor.features.delete(:part_of_time)
              ancestor.each_phrase { |phrase| phrase.features.delete(:time_link)}
            end
            ancestor = ancestor.parent
          end
        end
      end
    end
  end
end
