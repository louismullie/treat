class Treat::Helpers::Hash

  # Allow getting the caller method in any context.
  Hash.class_eval do
    # Converts a hash to nested structs.
    def self.hash_to_struct(hash)
      return hash if hash.keys.
      select { |k| !k.is_a?(Symbol) }.size > 0
      struct = Struct.new(*hash.keys).new(*hash.values)
      hash.each do |key, value|
        if value.is_a?(Hash)
          struct[key] = self.hash_to_struct(value)
        end
      end; return struct
    end
  end

end
