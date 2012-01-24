module Treat
  # Provides functions common to all algorithm categories.
  module Category
    require 'treat/group'
    def self.extended(category)
      Treat::Categories.list << category
      category.module_eval do
        groups.each do |group|
          group = const_get(group)
          group.targets.each do |entity_type|
            entity = Entities.const_get(cc(entity_type))
            entity.class_eval { add_delegators group }
          end
        end
      end
    end
    def groups; self.constants; end
    # Provide a list of methods implemented in
    # the groups contained within that
    def methods
      methods = []
      groups.each do |group|
        methods << const_get(group).method
      end
      methods
    end
  end
end
