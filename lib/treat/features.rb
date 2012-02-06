module Treat
  module Features
    Time = Struct.new(:start, :end, :recurrence, :recurrence_interval)
    Roles = Struct.new(:subject, :verb, :object, :patient, :agent)
    Date = Struct.new(:year, :month, :day)
  end
end
