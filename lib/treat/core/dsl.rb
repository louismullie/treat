module Treat::Core::DSL
  
  # Message for deprecation of old DSL syntax.
  DeprecationMessage = "The DSL that used " +
  "capitalized entity names is now deprecated. " +
  "Use `include Treat::Core::DSL` along with " +
  "lowercase names from now on." 
  
  # Map all classes in Treat::Entities to
  # a global builder function (entity, word,
  # phrase, punctuation, symbol, list, etc.)
  def self.included(base)
    Treat.core.entities.list.each do |type|
      kname = type.cc.intern
      mname = type.intern
      klass = Treat::Entities.const_get(kname)
      base.class_eval do
        define_method(mname.capitalize) do |*args|
          raise DeprecationMessage
        end
        old_mm = instance_method(:method_missing)
        define_method(:method_missing) do |sym,*args,&block|
          return klass.build(*args) if sym == mname
          return old_mm.bind(self).call(sym,*args,&block)
        end
      end
    end
  end
  
end