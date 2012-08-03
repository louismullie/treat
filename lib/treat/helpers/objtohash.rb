def object_to_hash(obj)
  hash = {}
  obj.instance_variables.each do |var|
    val = obj.instance_variable_get(var)
    hash[var.to_s.delete("@")] = val
  end
  hash
end