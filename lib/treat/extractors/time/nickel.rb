module Treat
  module Extractors
    module Time
      # A wrapper for the 'nickel' gem, which parses 
      # times and dates and supplies additional information
      # concerning these. The additional information supplied
      # that this class annotates entities with is:
      #
      # - time_recurrence: frequency of recurrence in words*.
      # - time_recurrence_interval: frequency of recurrence in days.
      # - start_time: a DateTime object representing the beginning of
      #   an event.
      # - end_time: a DateTime object representing the end of an event.
      # 
      # Examples of values for time_recurrence are:
      #
      # - single: "lunch with megan tomorrow at noon"
      # - daily: "Art exhibit until March 1st"
      # - weekly: "math class every wed from 8-11am"
      # - daymonthly: "open bar at joes the first friday of every month"
      # - datemonthly: "pay credit card bill on the 22nd of each month"
      # 
      # Project website: http://naturalinputs.com/
      module Nickel
        require 'date'
        silence_warnings { require 'nickel' }
        def self.time(entity, options = {})
          n = silence_warnings { ::Nickel.parse(entity.to_s) }
          occ = n.occurrences[0]
          # Find the words..
          rec = occ.type.to_s.gsub('single', 'once').intern
          entity.set :time_recurrence, rec
          interval = occ.interval ? occ.interval.intern : :none
          entity.set :time_recurrence_interval, interval

          s = [occ.start_date, occ.start_time]
          ds = [s[0].year, s[0].month, s[0].day] if s[0]
          ts = [s[1].hour, s[1].min, s[1].sec] if s[1]

          e = [occ.end_date, occ.end_time]
          de = [e[0].year, e[0].month, e[0].day] if e[0]
          te = [e[1].hour, e[1].min, e[1].sec] if e[1]

          entity.set :start_time, ::DateTime.civil(*ds, *ts) if ds
          entity.set :end_time, ::DateTime.civil(*de, *te) if de

          entity.start_time
        end
      end
    end
  end
end
