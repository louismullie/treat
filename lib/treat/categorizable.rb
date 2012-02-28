# A categorizable module brings together groups 
# of algorithms that perform similar functions.
module Treat::Categorizable
  
  # The contents of each categorizable 
  # module are groupable.
  require 'treat/groupable'
  
  # Add workers to the Entities based on the
  # configuration for a given category.
  def self.extended(category)
    Treat::Categories.list << category
    category.module_eval do
      groups.each do |group|
        group = const_get(group)
        group.targets.each do |entity_type|
          entity = Treat::Entities.
          const_get(cc(entity_type))
          entity.class_eval do
            add_workers group
          end
        end
      end
    end
  end
  
  # Get the list of groups defined
  # under this module.
  @@groups = self.constants
  
  # Populate a list of methods.
  @@methods = []
  @@groups.each do |group|
    @@methods << const_get(group).method
  end
  
  # Provide a list of methods implemented in
  # the groups contained within this category.
  def methods; @@methods; end
  
  # Provides a list of groups within this category.
  def groups; self.constants; end
  
end
