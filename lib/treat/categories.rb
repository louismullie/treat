module Treat
  # This module keeps track of all categories that
  # exist and the methods they implement.
  module Categories
    class << self; attr_accessor :list; end
    # Array - list of all categories.
    self.list = []
    @@lookup = {}
    # Find the class of a group given its method.
    def self.lookup(method)
      return @@lookup[method] unless @@lookup.empty?
      self.list.each do |category|
        category.groups.each do |group|
          group = category.const_get(group)
          @@lookup[group.method] = group
          group.decorators.each do |decorator,x|
            @@lookup[decorator] = group
          end
          group.presets.each do |preset,x|
            @@lookup[preset] = group
          end
        end
      end
      @@lookup[method]
    end
    require 'treat/category'
    require 'treat/detectors'
    require 'treat/formatters'
    require 'treat/processors'
    require 'treat/lexicalizers'
    require 'treat/extractors'
    require 'treat/inflectors'
  end
end
