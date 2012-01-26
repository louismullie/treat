class String
  def encode_compliant(encoding)
    encode!(encoding, :invalid => :replace, :undef => :replace, :replace => "?")
  end
end