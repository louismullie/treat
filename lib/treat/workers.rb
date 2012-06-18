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

  require 'treat/workers/group'

  # A lookup table for entity types.
  @@lookup = {}

  # Find a worker group based on method.
  def self.lookup(method)
    @@lookup[method]
  end

  def self.create_categories
    Treat.workers.list.each do |cat|
      create_category(cat.to_s.
      capitalize.intern,
      load_category_conf(cat))
    end
  end

  def self.load_category_conf(name)
    config = Treat.workers[name]
    if config.nil?
      raise Treat::Exception,
      "The configuration file " +
      "for #{cat_sym} is missing."
    end
    config
  end

  def self.create_category(name, conf)
    category = self.const_set(name, Module.new)
    conf.each_pair do |group, worker|
      name = group.to_s.capitalize.intern
      category.module_eval do
        @@methods = []; def methods; 
        @@methods; end; def groups; 
        self.constants; end
      end
      self.create_group(name, worker, category)
    end
  end

  def self.create_group(name, conf, category)
    group = category.const_set(name, Module.new)
    self.set_group_options(group, conf)
    self.bind_group_targets(group)
    self.register_group_presets(group, conf)
    @@methods << group.method
    @@lookup[group.method] = group
  end

  def self.bind_group_targets(group)
    group.targets.each do |entity_type|
      entity = Treat::Entities.
      const_get(cc(entity_type))
      entity.class_eval do
        add_workers group
      end
    end
  end

  def self.register_group_presets(group, conf)
    return unless conf.respond_to? :presets
    conf.presets.each do |m|
      @@methods << m
      @@lookup[m] = group
    end
  end

  def self.set_group_options(group, conf)
    group.module_eval do
      extend Treat::Workers::Group
      self.type = conf.type
      self.targets = conf.targets
      if conf.respond_to?(:default)
        self.default = conf.default
      end
      if conf.respond_to?(:preset_option)
        self.preset_option = conf.preset_option
      end
      if conf.respond_to?(:presets)
        self.presets = conf.presets
      end
    end
  end

  self.create_categories

end
