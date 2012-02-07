module Treat
  # This module keeps track of all categories that
  # exist and the methods they implement.
  module Categories
    class << self
      # A list of all categories.
      attr_accessor :list
    end
    # Array - list of all categories.
    self.list = []
    @@lookup = nil
    # Find the class of a group given its method.
    def self.lookup(method)
      return @@lookup[method] if @@lookup
      @@lookup = {}
      
      self.list.each do |category|
        category.groups.each do |group|
          group = category.const_get(group)
          @@lookup[group.method] = group
          methods = group.presets.merge(
            group.preprocessors.merge(
              group.postprocessors
            )
          )
          methods.each do |x,y|
            @@lookup[x] = group
          end
        end
      end
      
      @@lookup[method]
    end
    # Require all categories.
    require 'treat/category'
    require 'treat/formatters'
    require 'treat/processors'
    require 'treat/lexicalizers'
    require 'treat/inflectors'
    require 'treat/extractors'
    require 'treat/retrievers'
  end
end
