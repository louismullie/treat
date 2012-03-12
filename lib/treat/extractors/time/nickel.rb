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
class Treat::Extractors::Time::Nickel

  require 'date'

  silence_warnings { require 'nickel' }

  # Extract time information from a bit of text.
  def self.time(entity, options = {})
    
    s = entity.to_s
    return if s =~ /^[0-9]+$/
    
    n = nil
    
    begin
      silence_warnings { n = ::Nickel.parse(s.to_s.strip) }
    rescue
      return
    end
    
    occ = n.occurrences[0]
    
    return unless occ

    rec = occ.type.to_s.gsub('single', 'once').intern
    time_recurrence = rec
    interval = occ.interval ?
    occ.interval : :none
    time_recurrence_interval = interval


    s = [occ.start_date, occ.start_time]
    ds = [s[0].year, s[0].month, s[0].day] if s[0]
    ts = [s[1].hour, s[1].minute, s[1].second] if s[1]

    e = [occ.end_date, occ.end_time]
    de = [e[0].year, e[0].month, e[0].day] if e[0]
    te = [e[1].hour, e[1].minute, e[1].second] if e[1]

    start_time = ::DateTime.civil(*ds) if ds && !ts
    start_time = ::DateTime.civil(*ds, *ts) if ds && ts
    end_time = ::DateTime.civil(*de) if de && !te
    end_time = ::DateTime.civil(*de, *te) if de && te
    
    return unless start_time

    if entity.has_parent? && 
      remove_time_from_ancestors(entity, start_time)
      nil
    else
      entity.set :time_recurrence,
      time_recurrence
      entity.set :time_recurrence_interval,
      time_recurrence_interval
      entity.set :end_time, end_time if end_time
      start_time
    end
    
  end

  # Keeps the lowest-level time annotations that do
  # not conflict with a higher time annotation.
  # Returns true if the entity conflicts with a
  # higher-level time annotation.
  def self.remove_time_from_ancestors(entity, time)
    entity.ancestors_with_type(:phrase).each do |a|
      next if !a.has?(:time)
      return false unless a.get(:time).to_s == time.to_s
      a.unset(:time, :time_recurrence, 
      :time_recurrence_interval, :end_time)
    end
    true
  end

end
