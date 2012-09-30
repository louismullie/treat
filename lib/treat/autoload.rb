module Treat::Autoload
  
  # Loads all the files for the base
  # module in the appropriate order.
  def self.included(base)
    # Get the parts of module name.
    bits = base.to_s.split('::')
    # Get the module's name itself.
    name = bits[-1].downcase
    # Singularize the module name.
    n = self.singularize(n) + '.rb'
    d = File.join(Dir.pwd, 'lib/treat',
    bits[1..-1].collect! { |ch| ch.
    downcase }.join('/')) + '/'
    # Require base class if present.
    require d + n if File.readable?(d + n)
    # Require all other files in dir.
    Dir.glob("#{d}*.rb").each { |f| require f }
  end

  # Very naive singularization.
  # If ends in -ies, return -y form.
  # If ends in -s, return form w/o s.
  # Otherwise, return the original.
  def self.singularize(word)
    (w[-3..-1] == 'ies' ? (w[0..-4] + 'y') :
    (w[-1] == 's' ? w[0...-1] : w))
  end
  
end
