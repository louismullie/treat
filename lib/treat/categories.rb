module Treat
  # This module keeps track of all categories that
  # exist and the methods they implement, and is
  # responsible for including the categories.
  module Categories
    # A list of categories.
    class << self; attr_accessor :list; end
    self.list = []
    # Boolean - does any of the categories have 
    # a method that corresponds to sym?
    def self.have_method?(sym); methods.include?(sym); end
    # Cache the list of methods once it has been computed.
    @@methods = []
    # Provide a list of all methods implemented
    # by all Treat categories.
    def self.methods
      return @@methods unless @@methods.empty?
      self.list.each do |ns|
        ns.methods.each { |method| @@methods << method }
      end
      @@methods
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
