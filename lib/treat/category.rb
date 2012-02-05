module Treat
  # Clusters together groups of algorithms that
  # perform similar functions.
  module Category
    # Require the Group class.
    require 'treat/group'
    # Add workers to the Entities based on the
    # configuration for a given category.
    def self.extended(category)
      Treat::Categories.list << category
      category.module_eval do
        groups.each do |group|
          group = const_get(group)
          group.targets.each do |entity_type|
            entity = Treat::Entities.const_get(cc(entity_type))
            entity.class_eval { add_workers group }
          end
        end
      end
    end
    # Provides a list of groups within this category.
    def groups; self.constants; end
    # Provide a list of methods implemented in
    # the groups contained within this category.
    def methods
      methods = []
      groups.each do |group|
        methods << const_get(group).method
      end
      methods
    end
  end
end
