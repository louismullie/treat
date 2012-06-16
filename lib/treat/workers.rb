# This module keeps track of all the Treat::Categorizable
# modules that exist and the methods they define.
#
#
# - Processors perform the building of tree of
#   entities representing texts (chunking,
#   segmenting, tokenizing, parsing).
# - Lexicalizers give lexical information about
#   words (synsets, semantic relationships,
#   tag, word category).
# - Extractors extract semantic information about
#   an entity (language, topic, date, time, named
#   entity, coreferences).
# - Inflectors allow to retrieve the different
#   inflections of a word (declensors, conjugators,
#   stemmers, lemmatizers).
# - Formatters handle the conversion of entities to
#   and from different formats(readers, serializers,
#   unserializers, visualizers).
# - Retrievers allow to index and search collections
#   of documents.
module Treat::Workers

  require 'treat/workers/category'
  require 'treat/workers/group'

  # A lookup table for entity types.
  @@lookup = {}

  # Find a worker group based on method.
  def self.lookup(method)
    @@lookup[method]
  end
  
  def self.create_categories
    Treat.workers.list.each do |cat|
      create_category(cat)
    end
  end

  def self.create_category(cat_sym)

    cat_name = cat_sym.to_s.capitalize.intern    
    category = Treat.workers.send(cat_sym)
    
    if category.nil?
      raise Treat::Exception,
      "The configuration file for #{cat_sym} is missing."
    end
    
    cat_mod = self.const_set(cat_name, Module.new)

    cat_mod.module_eval do

      extend Treat::Workers::Category
      @@methods = []

      category.each do |group, worker|

        group = group.to_s.capitalize.intern
        group = cat_mod.const_set(group, Module.new)

        group.module_eval do
          extend Treat::Workers::Group
          self.type = worker[:type]
          self.targets = worker[:targets]
          self.default = worker[:default]
          self.preset_option = worker[:preset_option]
          self.presets = worker[:presets]
        end
    
        group.targets.each do |entity_type|
          entity = Treat::Entities.
          const_get(cc(entity_type))
          entity.class_eval do
            add_workers group
          end
        end
        
        @@methods << group.method
        unless worker[:presets].nil?
          worker[:presets].each do |m|
            @@methods << m
            @@lookup[m] = group
          end 
        end
        
        @@lookup[group.method] = group
        
      end

    end
  end

  self.create_categories
  
end
