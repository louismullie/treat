module Treat
  module Categories
    # Modify the module that includes Category to
    # setup autoload, delegators and provide a list
    # of methods.
    class << self; attr_accessor :list; end
    self.list = []
    # Boolean - does any of the categories
    # groups respond to the symbol.
    def self.have_method?(sym); methods.include?(sym); end
    # Provide a list of all methods implemented
    # by all Treat categories.
    @@methods = []
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
