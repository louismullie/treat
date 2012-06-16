# A categorizable module brings together groups 
# of algorithms that perform similar functions.
module Treat::Workers::Category
  
  # Provide a list of methods implemented in
  # the groups contained within this category.
  def methods; @@methods; end
  
  # Provides a list of groups within this category.
  def groups; self.constants; end
  
end