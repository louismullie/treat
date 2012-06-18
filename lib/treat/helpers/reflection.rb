# Return the name of the method that called the method
# that calls this method.
def caller_method(n = 3)
  at = caller(n).first
  /^(.+?):(\d+)(?::in `(.*)')?/ =~ at
  Regexp.last_match[3].gsub('block in ', '').intern
end

alias :cm :caller_method

Object.module_eval do
  # Unset a constant without private access.
  def self.const_unset(const)
    Object.instance_eval { remove_const(const) }
  end
end