# This is a module for complex features, i.e.
# features having more than one field. These
# are handled as Structs accepting a variable
# number of options.
module Treat::Entities::Features
  # A feature is just a struct.
  class Feature < ::Struct; end
  Time = Feature.new(:start, :end, :recurrence, :recurrence_interval)
  Linkages = Feature.new(:subject, :verb, :object)
  Roles = Feature.new(:patient, :agent)
  Date = Feature.new(:year, :month, :day)
end
