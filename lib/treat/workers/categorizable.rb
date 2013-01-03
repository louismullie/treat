# This module creates all the worker categories
# and the groups within these categories and adds
# the relevant hooks on the appropriate entities.
module Treat::Workers::Categorizable

  require_relative 'groupable'

  # A lookup table for entity types.
  @@lookup = {}

  # Find a worker group based on method.
  def lookup(method); @@lookup[method]; end

  def categorize!
    Treat.workers.members.each do |cat|
      name = cat.capitalize.intern
      conf = load_category_conf(cat)
      create_category(name, conf)
    end
  end

  def load_category_conf(name)
    if !Treat.workers.respond_to?(name)
      raise Treat::Exception,
      "The configuration file " +
      "for #{cat_sym} is missing."
    else
      Treat.workers[name]
    end
  end

  def create_category(name, conf)
    category = Treat::Workers.
    const_set(name, Module.new)
    conf.each_pair do |group, worker|
      name = group.to_s.cc.intern
      category.module_eval do
        @@methods = []
        def methods; @@methods; end
        def groups; self.constants; end
      end
      create_group(name, worker, category)
    end
  end

  def create_group(name, conf, category)
    group = category.const_set(name, Module.new)
    self.set_group_options(group, conf)
    self.bind_group_targets(group)
    self.register_group_presets(group, conf)
    @@methods << group.method
    @@lookup[group.method] = group
  end

  def set_group_options(group, conf)
    group.module_eval do
      extend Treat::Workers::Groupable
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
      if conf.respond_to?(:recursive)
        self.recursive = conf.recursive
      end
    end
  end

  def bind_group_targets(group)
    group.targets.each do |entity_type|
      entity = Treat::Entities.
      const_get(entity_type.cc)
      entity.class_eval do
        add_workers group
      end
    end
  end

  def register_group_presets(group, conf)
    return unless conf.respond_to?(:presets)
    conf.presets.each do |method|
      @@methods << method
      @@lookup[method] = group
    end
  end

end
