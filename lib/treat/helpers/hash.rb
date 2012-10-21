# Helper methods to manipulate hashes.
class Treat::Helpers::Hash

  # Mixin to allow conversion of hashes to
  # nested structs with the keys as attributes.
  module ToStruct
    # Converts a hash to nested structs.
    def to_struct
      hash = self
      symbols = hash.keys.select { |k| 
      !k.is_a?(Symbol) }.size
      return hash if symbols > 0
      klass = Struct.new(*hash.keys)
      struct = klass.new(*hash.values)
      hash.each do |key, value|
        if value.is_a?(Hash)
          v = value.to_struct
          struct[key] = v
        end
      end; return struct
    end
  end
  
  # Include the mixins on the core Hash class.
  Hash.class_eval do
    include Treat::Helpers::Hash::ToStruct
  end

end
