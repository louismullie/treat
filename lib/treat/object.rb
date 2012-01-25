# Make undefining constants publicly available on any object.
Object.module_eval do
  def self.const_unset(const)
    Object.instance_eval { remove_const(const) }
  end
end