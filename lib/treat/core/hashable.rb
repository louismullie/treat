module Treat::Core::Hashable

  def to_hash
    hash = {}
    instance_variables.each do |var|
      val = instance_variable_get(var)
      hash[var.to_s.delete("@")] = val
    end
    hash
  end
  
end
